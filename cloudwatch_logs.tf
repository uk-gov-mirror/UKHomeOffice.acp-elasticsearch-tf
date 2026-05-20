# AUDIT LOGS

locals {
  create_audit_log_group = var.manage_audit_log_group || var.audit_logs_enabled
}

resource "aws_cloudwatch_log_group" "elasticsearch_log_group" {
  count = local.create_audit_log_group ? 1 : 0
  name  = "${var.name}-log-group"

  tags = var.tags
}

resource "aws_cloudwatch_log_resource_policy" "elasticsearch_log_group_policy" {
  count = local.create_audit_log_group ? 1 : 0

  policy_name = "${var.name}-log-group-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_iam_user" "elasticsearch_audit_logs_iam_user" {
  count = var.audit_logs_enabled ? 1 : 0

  name = "${var.name}-Logs-User"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )

}

resource "aws_iam_policy" "elasticsearch_audit_log_policy" {
  count = var.audit_logs_enabled ? 1 : 0

  name        = "${var.name}-LogAccessPolicy"
  description = "Allows access to audit logs for the Elasticsearch instance: ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AccessESAuditLogs",
      "Effect": "Allow",
      "Action": [
        "logs:Describe*",
        "logs:Get*",
        "logs:List*",
        "logs:FilterLogEvents",
        "logs:TestMetricFilter",
        "logs:StartQuery",
        "logs:StopQuery"
      ],
      "Resource": "${aws_cloudwatch_log_group.elasticsearch_log_group[0].arn}:*"
    }
  ]
}
EOF

}

resource "aws_iam_user_policy_attachment" "elasticsearch_audit_log_policy_attachement" {
  count = var.audit_logs_enabled ? 1 : 0

  user       = aws_iam_user.elasticsearch_audit_logs_iam_user[0].name
  policy_arn = aws_iam_policy.elasticsearch_audit_log_policy[0].arn
}

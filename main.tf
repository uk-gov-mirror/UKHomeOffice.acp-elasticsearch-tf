locals {
  email_tags = { for i, email in var.email_addresses : "email${i}" => email }
}


resource "aws_elasticsearch_domain" "elasticsearch" {
  domain_name           = var.name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.zone_awareness_enabled

    dynamic "zone_awareness_config" {
      for_each = var.zone_awareness_enabled ? [true] : []
      content {
        availability_zone_count = var.zone_awareness_count
      }
    }
  }

  advanced_security_options {
    enabled = var.advanced_security_options_enabled

    internal_user_database_enabled = var.internal_user_database_enabled

    master_user_options {
      master_user_arn      = var.master_user_iam_enabled == true ? aws_iam_user.elasticsearch_iam_user.arn : null
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest_enabled
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  dynamic "vpc_options" {
    for_each = var.vpc_id == null ? [] : [var.vpc_id]
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = [aws_security_group.elasticsearch[0].id]
    }
  }

  domain_endpoint_options {
    enforce_https       = var.require_https
    tls_security_policy = var.tls_security_policy
  }

  dynamic "log_publishing_options" {
    for_each = local.create_audit_log_group ? [true] : []
    content {
      enabled                  = var.audit_logs_enabled
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.elasticsearch_log_group[0].arn
      log_type                 = "AUDIT_LOGS"
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_iam_user" "elasticsearch_iam_user" {
  name = "${var.name}-iam-user"
  path = "/"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )
}

resource "aws_iam_user_policy" "elasticsearch_iam_user_policy" {
  name = "${aws_iam_user.elasticsearch_iam_user.name}-policy"
  user = aws_iam_user.elasticsearch_iam_user.name

  policy = data.aws_iam_policy_document.elasticsearch_iam_user_policy_document.json
}

data "aws_iam_policy_document" "elasticsearch_iam_user_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "es:AssociatePackage",
      "es:Describe*",
      "es:DissociatePackage",
      "es:ListPackagesForDomain",
    ]

    resources = [aws_elasticsearch_domain.elasticsearch.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "es:CreatePackage",
      "es:DescribePackages",
    ]

    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.s3_bucket != null ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:GetObjectVersion",
      ]

      resources = ["${var.s3_bucket}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.s3_bucket_kms_key != null ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GetKeyPolicy",
        "kms:GenerateDataKeyWithoutPlaintext",
      ]

      resources = [var.s3_bucket_kms_key]
    }
  }
}

resource "aws_elasticsearch_domain_policy" "elasticsearch" {
  count       = var.policy != 0 ? 1 : 0
  domain_name = aws_elasticsearch_domain.elasticsearch.domain_name

  access_policies = var.policy != "default" ? var.policy : data.aws_iam_policy_document.elasticsearch_default_policy_document[0].json
}

data "aws_iam_policy_document" "elasticsearch_default_policy_document" {
  count   = var.policy != 0 ? 1 : 0
  version = "2012-10-17"
  statement {
    sid    = var.policy_sid
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.elasticsearch_iam_user.arn]
    }
    actions = [
      "es:*"
    ]
    resources = ["${aws_elasticsearch_domain.elasticsearch.arn}/*"]
  }
}

resource "aws_security_group" "elasticsearch" {
  count       = var.vpc_id == null ? 0 : 1
  name        = "${var.vpc_id}-elasticsearch-${var.name}"
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }
}

module "self_serve_access_keys" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys?ref=v0.1.0"

  user_names = aws_iam_user.elasticsearch_iam_user.*.name
}


resource "aws_iam_user" "elasticsearch_iam_users" {
  for_each = var.iam_users
  name     = "${var.name}-${each.key}-iam-user"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )
}

data "aws_iam_policy_document" "elasticsearch_iam_users_policy" {
  for_each = var.iam_users

  dynamic "statement" {
    for_each = each.value

    content {
      effect = "Allow"

      actions = [for method in statement.value.http_methods : format("es:ESHttp%s", method)]

      resources = [for path in statement.value.http_paths : format("${aws_elasticsearch_domain.elasticsearch.arn}/%s", path)]
    }
  }
}

resource "aws_iam_user_policy" "elasticsearch_iam_users_policy" {
  for_each = var.iam_users

  name = "${var.name}-${each.key}-policy"
  user = aws_iam_user.elasticsearch_iam_users[each.key].name

  policy = data.aws_iam_policy_document.elasticsearch_iam_users_policy[each.key].json
}

module "elasticsearch_iam_users_policy_self_serve_access" {
  for_each = var.iam_users

  source     = "git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys?ref=v0.1.0"
  user_names = [aws_iam_user.elasticsearch_iam_users[each.key].name]
}

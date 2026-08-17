variable "name" {
  type        = string
  description = "Name of the elasticsearch cluster"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  description = "The environment the elasticsearch cluster is running in i.e. dev, prod etc"
}

variable "elasticsearch_version" {
  type        = string
  default     = "6.3"
  description = "Version of Elasticsearch to deploy"
}

variable "instance_type" {
  type        = string
  default     = "t2.small.elasticsearch"
  description = "Elasticsearch instance type for data nodes in the cluster"
}

variable "instance_count" {
  description = "Number of data nodes in the cluster"
  default     = 4
}

variable "zone_awareness_enabled" {
  type        = string
  default     = "false"
  description = "Enable zone awareness for Elasticsearch cluster"
}

variable "zone_awareness_count" {
  default     = 2
  description = "Number of availability zones for zone awareness"
}

variable "ebs_volume_size" {
  description = "Optionally use EBS volumes for data storage by specifying volume size in GB"
  default     = 0
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes"
}

variable "ebs_iops" {
  default     = 0
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type"
}

variable "encrypt_at_rest_enabled" {
  type        = string
  default     = "false"
  description = "Whether to enable encryption at rest"
}

variable "log_publishing_index_enabled" {
  type        = string
  default     = "false"
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not"
}

variable "automated_snapshot_start_hour" {
  description = "Hour at which automated snapshots are taken, in UTC"
  default     = 0
}

variable "dedicated_master_enabled" {
  type        = string
  default     = "false"
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
}

variable "dedicated_master_count" {
  description = "Number of dedicated master nodes in the cluster"
  default     = 0
}

variable "dedicated_master_type" {
  type        = string
  default     = "t3.small.elasticsearch"
  description = "Instance type of the dedicated master nodes in the cluster"
}

variable "node_to_node_encryption_enabled" {
  type        = string
  default     = "false"
  description = "Whether to enable node-to-node encryption"
}

variable "policy" {
  description = "The JSON policy for the Elasticsearch"
  default     = "default"
}

variable "policy_sid" {
  description = "The SID for the default Elasticsearch policy statement. Override if the domain was originally created with a different SID to avoid perpetual drift."
  type        = string
  default     = "ElasticsearchPermissions"
}

variable "require_https" {
  type        = string
  default     = "false"
  description = "Determines whether https required for connections to this domain"
}

variable "vpc_id" {
  description = "The VPC ID to create the resources within"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of subnet IDs associated to a vpc, for vpc domains"
  default     = []
}

variable "cidr_blocks" {
  type        = list(string)
  description = "A list of network cidr block which are permitted acccess to a vpc domain"
  default     = ["0.0.0.0/0"]
}

variable "email_addresses" {
  type        = list(string)
  description = "A list of email addresses for key rotation notifications."
  default     = []
}

variable "key_rotation" {
  description = "Enable email notifications for old IAM keys."
  default     = "true"
}

variable "s3_bucket" {
  description = "Allow ES user to get objects from specified bucket"
  default     = null
}

variable "s3_bucket_kms_key" {
  description = "Allow ES user to use specified KMS key to decrypt objects from given bucket"
  default     = null
}

variable "master_user_iam_enabled" {
  description = "If set to true, the IAM user created by this module will be the master user of the domain."
  default     = false
}

variable "master_user_name" {
  default = ""
}

variable "master_user_password" {
  description = "The master user password must contain at least one uppercase letter, one lowercase letter, one number, and one special character."
  default     = ""
}

variable "advanced_security_options_enabled" {
  type        = bool
  description = "Enable advanced security option"
  default     = false
}

variable "internal_user_database_enabled" {
  type        = bool
  description = "Enable the internal user database"
  default     = false
}

variable "audit_logs_enabled" {
  type        = bool
  description = "Enable audit logging for the Elasticsearch instance"
  default     = false
}

variable "manage_audit_log_group" {
  type        = bool
  description = "Manage the audit-log CloudWatch log group and its log resource policy. Defaults to true so existing domains keep them on upgrade. The log group is always created when audit_logs_enabled is true. When both this and audit_logs_enabled are false, no log_publishing_options block is sent for the domain. Only set false where the domain has no existing log publishing configuration in AWS - a plan showing log_publishing_options being added confirms there is none."
  default     = true
}

variable "tls_security_policy" {
  type        = string
  description = "Default TLS security policy. Which controls the minimum TLS version required for traffic to the domain. Valid values Policy-Min-TLS-1-0-2019-07 Policy-Min-TLS-1-2-2019-07"
  default     = "Policy-Min-TLS-1-2-2019-07"
  validation {
    condition     = contains(["Policy-Min-TLS-1-2-2019-07", "Policy-Min-TLS-1-0-2019-07"], var.tls_security_policy)
    error_message = "Valid values for tls_security_policy are: (Policy-Min-TLS-1-2-2019-07, Policy-Min-TLS-1-0-2019-07)."
  }
}

variable "iam_users" {
  type = map(list(object({
    http_methods = list(string)
    http_paths   = list(string)
  })))
  description = "IAM users to create and their allowed HTTP paths and methods"

  validation {
    condition = alltrue(
      [for user in var.iam_users : alltrue(
        [for policy in user : alltrue(
    [for method in policy.http_methods : contains(["POST", "GET", "PUT", "DELETE", "HEAD", "PATCH", "*"], upper(method))])])])
    error_message = "Supported types are '*', 'POST', 'GET', 'PUT', 'DELETE', 'HEAD' and 'PATCH'."
  }
}
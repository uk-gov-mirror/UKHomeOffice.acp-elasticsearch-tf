## Upgrading
### v1 to v2

Version 2 the input variable tls_security_policy was implemented with a default of TLS 1.2, unless the tenant has agreed to change the minimum TLS version this should be set to "Policy-Min-TLS-1-0-2019-07".

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_elasticsearch_iam_users_policy_self_serve_access"></a> [elasticsearch\_iam\_users\_policy\_self\_serve\_access](#module\_elasticsearch\_iam\_users\_policy\_self\_serve\_access) | git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys | v0.1.0 |
| <a name="module_self_serve_access_keys"></a> [self\_serve\_access\_keys](#module\_self\_serve\_access\_keys) | git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys | v0.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.elasticsearch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.elasticsearch_log_group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.elasticsearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_elasticsearch_domain_policy.elasticsearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_policy) | resource |
| [aws_iam_policy.elasticsearch_audit_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.elasticsearch_audit_logs_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.elasticsearch_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.elasticsearch_iam_users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.elasticsearch_iam_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy.elasticsearch_iam_users_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy_attachment.elasticsearch_audit_log_policy_attachement](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_security_group.elasticsearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.elasticsearch_default_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elasticsearch_iam_user_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elasticsearch_iam_users_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | Enable advanced security option | `bool` | `false` | no |
| <a name="input_audit_logs_enabled"></a> [audit\_logs\_enabled](#input\_audit\_logs\_enabled) | Enable audit logging for the Elasticsearch instance | `bool` | `false` | no |
| <a name="input_automated_snapshot_start_hour"></a> [automated\_snapshot\_start\_hour](#input\_automated\_snapshot\_start\_hour) | Hour at which automated snapshots are taken, in UTC | `number` | `0` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | A list of network cidr block which are permitted acccess to a vpc domain | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_create_log_resource_policy"></a> [create\_log\_resource\_policy](#input\_create\_log\_resource\_policy) | Create the CloudWatch log resource policy that permits the Elasticsearch service to write audit logs. The policy is account-wide and its document is identical for every domain, so a single grant covers every domain in the account, and AWS allows only 10 per region per account. Defaults to false because a duplicate consumes the limit without granting anything further. Set true only in an account that holds no equivalent grant. Has no effect when no log group is managed. | `bool` | `false` | no |
| <a name="input_dedicated_master_count"></a> [dedicated\_master\_count](#input\_dedicated\_master\_count) | Number of dedicated master nodes in the cluster | `number` | `0` | no |
| <a name="input_dedicated_master_enabled"></a> [dedicated\_master\_enabled](#input\_dedicated\_master\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster | `string` | `"false"` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | Instance type of the dedicated master nodes in the cluster | `string` | `"t3.small.elasticsearch"` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type | `number` | `0` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Optionally use EBS volumes for data storage by specifying volume size in GB | `number` | `0` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Storage type of EBS volumes | `string` | `"gp2"` | no |
| <a name="input_elasticsearch_version"></a> [elasticsearch\_version](#input\_elasticsearch\_version) | Version of Elasticsearch to deploy | `string` | `"6.3"` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list(string)` | `[]` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Whether to enable encryption at rest | `string` | `"false"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the elasticsearch cluster is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_iam_users"></a> [iam\_users](#input\_iam\_users) | IAM users to create and their allowed HTTP paths and methods | <pre>map(list(object({<br>    http_methods = list(string)<br>    http_paths   = list(string)<br>  })))</pre> | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of data nodes in the cluster | `number` | `4` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Elasticsearch instance type for data nodes in the cluster | `string` | `"t2.small.elasticsearch"` | no |
| <a name="input_internal_user_database_enabled"></a> [internal\_user\_database\_enabled](#input\_internal\_user\_database\_enabled) | Enable the internal user database | `bool` | `false` | no |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| <a name="input_log_publishing_index_enabled"></a> [log\_publishing\_index\_enabled](#input\_log\_publishing\_index\_enabled) | Specifies whether log publishing option for INDEX\_SLOW\_LOGS is enabled or not | `string` | `"false"` | no |
| <a name="input_manage_audit_log_group"></a> [manage\_audit\_log\_group](#input\_manage\_audit\_log\_group) | Manage the audit-log CloudWatch log group. Defaults to true so existing domains keep it on upgrade. The log group is always created when audit\_logs\_enabled is true. When both this and audit\_logs\_enabled are false, no log\_publishing\_options block is sent for the domain. Only set false where the domain has no existing log publishing configuration in AWS - a plan showing log\_publishing\_options being added confirms there is none. The log resource policy is controlled separately by create\_log\_resource\_policy. | `bool` | `true` | no |
| <a name="input_master_user_iam_enabled"></a> [master\_user\_iam\_enabled](#input\_master\_user\_iam\_enabled) | If set to true, the IAM user created by this module will be the master user of the domain. | `bool` | `false` | no |
| <a name="input_master_user_name"></a> [master\_user\_name](#input\_master\_user\_name) | n/a | `string` | `""` | no |
| <a name="input_master_user_password"></a> [master\_user\_password](#input\_master\_user\_password) | The master user password must contain at least one uppercase letter, one lowercase letter, one number, and one special character. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the elasticsearch cluster | `string` | n/a | yes |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption | `string` | `"false"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The JSON policy for the Elasticsearch | `string` | `"default"` | no |
| <a name="input_policy_sid"></a> [policy\_sid](#input\_policy\_sid) | The SID for the default Elasticsearch policy statement. Override if the domain was originally created with a different SID to avoid perpetual drift. | `string` | `"ElasticsearchPermissions"` | no |
| <a name="input_require_https"></a> [require\_https](#input\_require\_https) | Determines whether https required for connections to this domain | `string` | `"false"` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Allow ES user to get objects from specified bucket | `any` | `null` | no |
| <a name="input_s3_bucket_kms_key"></a> [s3\_bucket\_kms\_key](#input\_s3\_bucket\_kms\_key) | Allow ES user to use specified KMS key to decrypt objects from given bucket | `any` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnet IDs associated to a vpc, for vpc domains | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | Default TLS security policy. Which controls the minimum TLS version required for traffic to the domain. Valid values Policy-Min-TLS-1-0-2019-07 Policy-Min-TLS-1-2-2019-07 | `string` | `"Policy-Min-TLS-1-2-2019-07"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID to create the resources within | `any` | `null` | no |
| <a name="input_zone_awareness_count"></a> [zone\_awareness\_count](#input\_zone\_awareness\_count) | Number of availability zones for zone awareness | `number` | `2` | no |
| <a name="input_zone_awareness_enabled"></a> [zone\_awareness\_enabled](#input\_zone\_awareness\_enabled) | Enable zone awareness for Elasticsearch cluster | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domain_arn"></a> [domain\_arn](#output\_domain\_arn) | ARN of the Elasticsearch domain |
| <a name="output_domain_endpoint"></a> [domain\_endpoint](#output\_domain\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the Elasticsearch domain |
<!-- END_TF_DOCS -->

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

variable "cust_scope" {
  default = "/subscriptions/d6bc91f0-7f68-44ec-afd8-78acece5b3c0"
}
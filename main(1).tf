terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}
provider "aws" {
  #for_each = { for BudgetName in local.csvfld : BudgetName.BudgetName => BudgetName }
  #assume_role {
  #role_arn    = "arn:aws:iam::[each.valueAWSAccountNumber]:role/role_XXX"
  #external_id = "my_external_id"  
}

locals {
  csvfld = csvdecode(file("./csvdata.csv"))
}

resource "aws_budgets_budget" "budget_notification" {
  for_each          = { for BudgetName in local.csvfld : BudgetName.BudgetName => BudgetName }
  name              = each.value.BudgetName
  budget_type       = "COST"
  limit_amount      = each.value.BudgetAmount
  limit_unit        = "USD"
  time_period_start = each.value.StartMonth
  time_period_end   = each.value.EndMonth
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = each.value.Alert1Trigger
    subscriber_email_addresses = [each.value.Alert1Emails]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = each.value.Alert2Trigger
    subscriber_email_addresses = [each.value.Alert2Emails]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = each.value.Alert3Trigger
    subscriber_email_addresses = [each.value.Alert3Emails]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = each.value.Alert4Trigger
    subscriber_email_addresses = [each.value.Alert4Emails]
  }

}


output "csvdata" {
  value = local.csvfld
}

remote_state {
    backend = "gcs"
    config = {
      bucket = "gc-ue4-gcs-tf-pr-2"
      prefix = "terraform/3-shared/devops"
    }
  }
terraform {
  extra_arguments "common_vars" {
      commands = get_terraform_commands_that_need_vars()

      arguments = [
        "-lock-timeout=20m",
        "-var-file=../../envars/common.tfvars.json",
        "-var-file=../../envars/${get_env("ENV", "default")}.tfvars.json",
      ]
  }
}
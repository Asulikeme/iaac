locals {
  pocprojects = [
      {
          application_code = "dba-"
          project_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "dba"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "oracle-apps"
            maintenance-window = "na"
            os = "na"
        }
     
  
    standard_apis = concat (var.gc_proj_standard_apis,["run.googleapis.com"])
    iam_permission = [
        {
          group_email = "enterpriseapplications@cswg.com"
          iam_roles = ["roles/owner"]
        }
      ]
    
    notification_recipients = ["yelbakha@cswg.com"]
     },
######
     {
          application_code = "wbprtl-"
          project_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "wbprtl"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "webportal"
            maintenance-window = "na"
            os = "na"
        }
     
  
    standard_apis = concat (var.gc_proj_standard_apis,["run.googleapis.com"])
    iam_permission = [
        {
          group_email = "webportalteam@cswg.com"
          iam_roles = ["roles/owner"]
        }
      ]
    
    notification_recipients = ["yelbakha@cswg.com"]
    },
######
         {
          application_code = "devis-"
          project_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "devis"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "dev_isbd_team"
            maintenance-window = "na"
            os = "na"
        }
     
  
    standard_apis = concat (var.gc_proj_standard_apis,["run.googleapis.com"])
    iam_permission = [
        {
          group_email = "dev_isbd_team@cswg.com"
          iam_roles = ["roles/owner"]
        }
      ]
    
    notification_recipients = ["yelbakha@cswg.com"]
    },
######
         {
          application_code = "easvc-"
          project_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "easvc"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "dev_isbd_team"
            maintenance-window = "na"
            os = "na"
        }
     
  
    standard_apis = concat (var.gc_proj_standard_apis,["run.googleapis.com"])
    iam_permission = [
        {
          group_email = "dev_isbd_team@cswg.com"
          iam_roles = ["roles/owner"]
        }
      ]
    
    notification_recipients = ["yelbakha@cswg.com"]
    },
######
         {
          application_code = "ensy-"
          project_labels = {
            org = "cswg"
            env = "poc"
            cost-center = "is310"
            app-code = "ensy"
            department = "is"
            bucket-name = "na"
            backup = "na"
            created-by = "terraform"
            owner-maintainer = "cloud-team"
            primary-app-owner = "ensy"
            maintenance-window = "na"
            os = "na"
        }
     
  
    standard_apis = concat (var.gc_proj_standard_apis,["run.googleapis.com"])
    iam_permission = [
        {
          group_email = "intelsystemsgroup@cswg.com"
          iam_roles = ["roles/owner"]
        }
      ]
    
    notification_recipients = ["yelbakha@cswg.com"]
    }
  ]
}
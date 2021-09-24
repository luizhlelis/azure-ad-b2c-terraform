# Configure Terraform
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.4.0"
    }
  }
}

# Configure the Azure Active Directory as the Provider
provider "azuread" { }

# Retrieve domain information
data "azuread_domains" "django_azure_b2c_auth" {
  only_initial = true
}

# Client application section
data "azuread_client_config" "current" {}

resource "azuread_application" "django_azure_b2c_auth" {
  display_name     = "django-azure-b2c-auth"
  sign_in_audience = "AzureADMultipleOrgs"
  logo_image       = filebase64("${path.module}/assets/code.png")

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access django-azure-b2c-auth on behalf of the signed-in user."
      admin_consent_display_name = "Access django-azure-b2c-auth"
      enabled                    = true
      id                         = "8cc1d386-1c7a-11ec-9621-0242ac130002"
      type                       = "User"
      user_consent_description   = "Allow the application to access example on your behalf."
      user_consent_display_name  = "Access django-azure-b2c-auth"
      value                      = "user_impersonation"
    }
  }

  app_role {
    allowed_member_types = ["User", "Application"]
    description          = "Admins can manage roles and perform all task actions"
    display_name         = "Admin"
    enabled              = true
    id                   = "f4a11d7c-1c7a-11ec-9621-0242ac130002"
    value                = "admin"
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
  }

  web {
    homepage_url  = "http://localhost:8000"
    logout_url    = "https://localhost:8000/logout"
    redirect_uris = ["http://localhost:8000/api/v1/response-oidc"]

    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = false
    }
  }
}

resource "azuread_application_password" "django_azure_b2c_auth" {
  display_name          = format("%s-%s",azuread_application.django_azure_b2c_auth.display_name,"client-secret")
  application_object_id = azuread_application.django_azure_b2c_auth.object_id
}
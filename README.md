# Azure AD B2C with Terraform

## Configuring the Terraform App Registration in AD B2C

Create a new [App registration](https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-ga#register-a-web-application) in Azure AD B2C and then a new [Client Secret](https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-ga#create-a-client-secret) for your `App registration`. You're gonna use that `Client Secret` as credentials for the Terraform provider.

When authenticated with a service principal, this resource requires one of the following application roles: `Application.ReadWrite.All` or `Directory.ReadWrite.All`. Along with that, to enable terraform to read the domain information, it's required to grant the `Domain.Read.All` role.

> **NOTE:** choose for `Microsoft Graph` when adding permissions to the application. It's important to `Grant admin consent` for those permissions because they require a high level access. If you're not an admin, contact the account administrator.

## Storing the credentials as Environment Variables

First, you need to store the credentials in environment variables:

```bash
export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="MyCl1eNtSeCr3t"
export ARM_TENANT_ID="10000000-2000-3000-4000-500000000000"
```

## Running it locally

```bash
terraform init
````

```bash
terraform plan
```

```bash
terraform apply
```

Type the following command to see the output credentials from the just created `App Registration`:

```bash
terraform output app_registration_client_secret_key_id
```

```bash
terraform output app_registration_client_secret_value
```

## Custom policies

Firslty, you need to create a new `Policy Key` in Azure B2C called `TokenSigningKeyContainer` and another called `B2C_1A_FacebookSecret` as signature, finally one called `TokenEncryptionKeyContainer` as encryption.


locals {
  b2c_file_paths = fileset(path.module, "infrastructure/resources/b2c-polices/*")
  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    basename(b2c_file_path) => {
      name = basename(b2c_file_path)
      path = "${path.module}/${b2c_file_path}"
      content = contains(local.image_ext, split(".", b2c_file_path)[1]) ? "" : replace(replace(replace(replace(replace(file("${path.module}/${b2c_file_path}"),
        "{StorageAccountUrl}", module.sa.storageaccount_primary_blob_endpoint),
        "{WebsiteUrl}", local.frontend_url),
        "{B2cContainer}", local.b2c_container_name),
        "{B2cSignInUrl}", local.b2c_signin_endpoint_url),
      "{B2cStaffUrl}", local.b2c_staff_endpoint_url)
      content_type = (split(".", b2c_file_path)[1] == "css" ? "text/css" :
        split(".", b2c_file_path)[1] == "png" ? "image/png" :
        split(".", b2c_file_path)[1] == "svg" ? "image/svg+xml" :
        split(".", b2c_file_path)[1] == "ico" ? "image/vnd.microsoft.icon" :
        split(".", b2c_file_path)[1] == "html" ? "text/html" :
        split(".", b2c_file_path)[1] == "xml" ? "application/xml" :
      "")
    }
  }

  image_ext = ["png", "svg", "ico"]
  file_ext  = ["css", "html", "xml"]
}

resource "azurerm_storage_blob" "b2c_policy_images" {
  for_each               = { for k, v in local.b2c_file_details : k => v if contains(local.image_ext, split(".", v.path)[1]) }
  name                   = each.value.name
  storage_account_name   = module.sa.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = each.value.path
  content_type           = each.value.content_type

  depends_on = [
    module.sa
  ]
}

resource "azurerm_storage_blob" "b2c_policy_files" {
  for_each               = { for k, v in local.b2c_file_details : k => v if contains(local.file_ext, split(".", v.path)[1]) }
  name                   = each.value.name
  storage_account_name   = module.sa.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source_content         = each.value.path
  content_type           = each.value.content_type

  depends_on = [
    module.sa
  ]
}

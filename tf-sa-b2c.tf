
locals {
  b2c_file_paths = fileset(path.module, "infrastructure/resources/b2c-polices/*")
  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    basename(b2c_file_path) => {
      name      = basename(b2c_file_path)
      file_name = b2c_file_path
      path      = "${path.module}/${b2c_file_path}"
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
        split(".", b2c_file_path)[1] == "woff" ? "font/woff" :
        split(".", b2c_file_path)[1] == "woff2" ? "font/woff2" :
      "")
    }
  }

  image_ext = ["png", "svg", "ico"]
  file_ext  = ["css", "html", "xml", "woff", "woff2"]

  b2c_image_files = { for k, v in local.b2c_file_details : k => v if contains(local.image_ext, split(".", v.file_name)[1]) }
  b2c_file_files  = { for k, v in local.b2c_file_details : k => v if contains(local.file_ext, split(".", v.file_name)[1]) }
}
output "b2c_image_files" {
  value = local.b2c_image_files
}
output "b2c_file_files" {
  value = local.b2c_file_files
}

resource "azurerm_storage_blob" "b2c_policy_images" {
  for_each               = local.b2c_image_files
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
  for_each               = local.b2c_file_files
  name                   = each.value.name
  storage_account_name   = module.sa.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source_content         = each.value.content
  content_type           = each.value.content_type

  depends_on = [
    module.sa
  ]
}

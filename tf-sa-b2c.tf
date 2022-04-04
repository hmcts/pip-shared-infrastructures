
locals {
  b2c_file_paths = fileset(path.module, "infrastructure/resources/b2c-polices/*")
  b2c_file_details = {
    for b2c_file_path in local.b2c_file_paths :
    basename(b2c_file_path) => {
      name = basename(b2c_file_path)
      path = "${path.module}/${b2c_file_path}"
      content_type = (split(".", b2c_file_path)[1] == "css" ? "text/css" :
        split(".", b2c_file_path)[1] == "png" ? "image/png" :
        split(".", b2c_file_path)[1] == "svg" ? "image/svg+xml" :
        split(".", b2c_file_path)[1] == "ico" ? "image/vnd.microsoft.icon" :
        split(".", b2c_file_path)[1] == "html" ? "text/html" :
        split(".", b2c_file_path)[1] == "xml" ? "application/xml" :
      "")
    }
  }
}

resource "azurerm_storage_blob" "b2c_policy_files" {
  for_each               = local.b2c_file_details
  name                   = each.value.name
  storage_account_name   = module.sa.storageaccount_name
  storage_container_name = local.b2c_container_name
  type                   = "Block"
  source                 = each.value.path
  content_type           = each.value.content_type
}

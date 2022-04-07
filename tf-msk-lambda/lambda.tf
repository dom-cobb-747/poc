###################
# Lambda
###################


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./disable_access_keys.zip"
}

resource "aws_lambda_function" "accesskey_disabler_lambda" {
  depends_on = [data.archive_file.lambda_zip]

  filename         = "./disable_access_keys.zip"
  function_name    = "accesskey-disabler-${var.stage}"
  role             = aws_iam_role.disable_accesskey_lambda_role.arn
  handler          = "disable_access_keys.lambda_handler"
  source_code_hash = fileexists("./disable_access_keys.zip") ? filebase64sha256("./disable_access_keys.zip") : "0"
  runtime          = "node14.0"
  timeout          = 600
  memory_size      = 1024
  publish          = true

  environment {
    variables = {
      Stage = var.stage
      Region = var.region
    }
  } 
}
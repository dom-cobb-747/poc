###################
# Lambda
###################


data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./msk-lambda-apig-src.zip"
}

resource "aws_lambda_function" "lambda_poc" {
  depends_on = [data.archive_file.lambda_zip]

  filename         = "./msk-lambda-apig-src.zip"
  function_name    = "msk-lambda-apig-${var.stage}"
  role             = aws_iam_role.msk_lambda_apig_role.arn
  handler          = "handler.handler"
  source_code_hash = fileexists("./msk-lambda-apig-src.zip") ? filebase64sha256("./msk-lambda-apig-src.zip") : "0"
  runtime          = "nodejs14.x"
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
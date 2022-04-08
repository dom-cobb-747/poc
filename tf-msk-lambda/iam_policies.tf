###################
# Policies
###################


resource "aws_iam_role" "msk_lambda_apig_role" {
  name = "msk-lambda-apig-${var.stage}-${var.region}-role"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


resource "aws_iam_policy" "msk_lambda_apig_policy" {

  name = "msk-lambda-apig-${var.stage}-${var.region}-policy"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "logs:CreateLogGroup",
      "Resource": "arn:aws:logs:${var.region}:*" 
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:*"   
    }
  ]
}
  EOF
}


// Attach IAM policy to IAM role

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.msk_lambda_apig_role.name
  policy_arn = aws_iam_policy.msk_lambda_apig_policy.arn
}

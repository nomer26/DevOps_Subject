# # ALB Ingress Controller 
# resource "aws_iam_role" "alb-ingress-controller" {
#     name = "alb-ingress-controller"

#     assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_policy" "alb-ingress-controller-policy" {
#     name = "alb-ingress-controller"
#     description = "ALB Ingress Controller Policy"
#     policy = data.template_file.alb-ingress-controller.rendered
  
# }
# data "template_file" "alb-ingress-controller" {
#     template = "${file("${path.module}/alb-ingress-controller-policy.json")}"
# }

# resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
#   role = aws_iam_role.alb-ingress-controller.name
#   policy_arn = aws_iam_policy.alb-ingress-controller-policy.arn
# }
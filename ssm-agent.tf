resource "aws_iam_policy" "ssm_agent_policy" {
  name        = "SSMAgentPolicy"
  description = "Policy for SSM Agent access"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SSMAgentPolicy",
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeInstanceInformation",
        "ssm:ListCommands",
        "ssm:ListCommandInvocations",
        "ssm:SendCommand",
        "ssm:GetCommandInvocation"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ssm_agent_instance_profile" {
  name = "SSMAgentInstanceProfile"
  role = aws_iam_role.ssm_agent_role.name
}

resource "aws_iam_role" "ssm_agent_role" {
  name               = "SSMAgentRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_agent_policy_attachment" {
  role       = aws_iam_role.ssm_agent_role.name
  policy_arn = aws_iam_policy.ssm_agent_policy.arn
}

/* resource "aws_instance" "example_instance" {
  # EC2 instance configuration...

  iam_instance_profile = aws_iam_instance_profile.ssm_agent_instance_profile.name

  # Other instance settings...
} */

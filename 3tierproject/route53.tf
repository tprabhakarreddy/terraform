
# # Create a Route 53 hosted zone (or you can use an existing one)
# resource "aws_route53_zone" "route53_zone" {
#   name = "rds.com" # Replace with your domain
#   vpc {
#     vpc_id = aws_vpc.myvpc.id

#   }
#   depends_on = [ aws_vpc.myvpc ]
#   tags = {
#     Name = "PrivateHostedZone"
#   }
# }

# # Create a public DNS record pointing to the RDS instance endpoint
# resource "aws_route53_record" "rds_route53_record" {
#   zone_id    = aws_route53_zone.route53_zone.id
#   name       = "book.rds.com" # Replace with your desired subdomain
#   type       = "CNAME"
#   ttl        = 60
#   records    = [aws_db_instance.mysql_db.endpoint]
#   depends_on = [aws_db_instance.mysql_db]
# }


# # Create Backend DNS Record in Route 53
# resource "aws_route53_record" "backend_record" {
#   zone_id = data.aws_route53_zone.public_zone.id
#   name    = "app.clouddevops.co.in" # Replace with your desired backend domain name
#   type    = "A"
#   alias {
#     name = aws_lb.BackEnd-alb.dns_name
#     zone_id = aws_lb.BackEnd-alb.zone_id
#     evaluate_target_health = true
#   }
 
# }
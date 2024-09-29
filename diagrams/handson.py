from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.general import Client
from diagrams.aws.network import (
    VPC,
    InternetGateway,
    NATGateway,
    PrivateSubnet,
    PublicSubnet,
    RouteTable,
)

with Diagram("AWS VPC Infrastructure", show=False):
    # VPC
    with Cluster("VPC: upgrad-vpc"):
        vpc = VPC("VPC")

        # Internet Gateway and NAT Gateway
        igw = InternetGateway("upgrad-igw")
        nat = NATGateway("upgrad-nat")

        # Subnets
        with Cluster("Public Subnets"):
            public_subnet1 = PublicSubnet("upgrad-public-1 (10.100.1.0/24)")
            public_subnet2 = PublicSubnet("upgrad-public-2 (10.100.2.0/24)")

        with Cluster("Private Subnets"):
            private_subnet1 = PrivateSubnet("upgrad-private-1 (10.100.3.0/24)")
            private_subnet2 = PrivateSubnet("upgrad-private-2 (10.100.4.0/24)")

        # Route Tables
        public_route_table = RouteTable("public-rt")
        private_route_table = RouteTable("private-rt")

        # EC2 instance
        ec2 = EC2("EC2 WordPress")

        # RDS instance
        rds = RDS("RDS MySQL")

        # Diagram connections
        vpc >> [public_subnet1, public_subnet2, private_subnet1, private_subnet2]
        vpc >> igw >> public_route_table
        public_route_table >> [public_subnet1, public_subnet2]
        vpc >> nat >> private_route_table >> [private_subnet1, private_subnet2]

        ec2 >> public_subnet1
        rds >> [private_subnet1, private_subnet2]

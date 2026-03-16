# Security Policies

- No port 80 exposed to public internet
- All applications MUST enforce TLS 1.2+ for communication in transit
- Data MUST be encrypted at rest using the service's default KMS encryption
- Application MUST use Authentication and Authorization to prevent unauthenticated/unauthorized access
- Application domain MUST be an AWS owned and managed domain (subdomain of people.aws.dev)

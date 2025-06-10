## About

App Name:  AWS Customer CRUD


## AI Prompt Context Instructions

  - Always include metadata header section for project at the top of each source code file.
  - Definition of Metadata header section:

      ```markdown
      # App: {{App Name}}
      # Package: {{package}}
      # File: {{file name}}
      # Version: 0.0.1
      # Author: Bobwares
      # Date: {{current date/ time}}
      # Description: document the function of the code.
      #
      ```

### version.md
- create file version.md with updated version number and list of changes. Include date and time of change.
- start version at 0.0.1
  - Update version each time the code is updated.  
  - Update only code or configuration files that have changed.
 
### Coding Rules
  - follow code formatting standards:
      - Python: PEP 8: E303 too many blank lines (2)

### Tests

- Always generate unit tests
- Always include integration tests when appropriate.
- create .http tests under directory project_root/e2e

### Implementation

- Refer to ./docs/aws-single-table-crud-python.md for instructions for generating application
- Refer to ./schemas/customer_domain.json for the domain objects.

# References

https://github.com/hashicorp/terraform

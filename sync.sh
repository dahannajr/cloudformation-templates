#!/bin/bash

AWS_PROFILE=ks aws s3 sync . s3://kickstep-cf-templates/${1} --include "*" --exclude ".git/**"
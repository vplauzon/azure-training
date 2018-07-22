New-AzureRmResourceGroup -Name paas-tour -Location eastus2 -Force

New-AzureRmResourceGroupDeployment -ResourceGroupName paas-tour `
                                    -TemplateFile 'paas-tour-arm-template.json' `
                                    -TemplateParameterFile 'paas-tour-arm-template.parameters.json' `
                                    -Force -Verbose `
                                    -ErrorVariable ErrorMessages

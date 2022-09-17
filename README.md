<!-- markdownlint-configure-file {
  "MD033": false,
  "MD041": false
} -->

# apigee-core-yaml-pipeline-templates

<div align="center">

[Key Features](#key-features) •
[The Why?](#the-why) •
[Developed By](#%EF%B8%8F-developed-by) •
[Getting Started](#getting-started) •
[Author](#book-author)

<img src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg" alt="Awesome Badge"/>
<img src="https://img.shields.io/pypi/status/ansicolortags.svg" alt="Stars Badge"/>

<br />

`apigee-core-yaml-pipeline-templates` is a centralized build and release [Azure DevOps Pipelines][azure-pipelines] framework developed with the purpose to modernize CI/CD as a code for [Apigee][apigee] core components including: [API Proxies][apigee-api-proxy], [Shared Flows][apigee-sf], [KVMs][apigee-kvm], ...etc

</div>

<br />

## Key Features

- Supports Apigee X / Hybrid.
- Supports API proxies deployment using [Apigee Deploy Maven Plugin][apigee-deploy-mvn] & [Apigee Config Maven Plugin][apigee-config-mvn].
- Follows best practices.
- Fully decoupled CI/CD.
- Easy to use.
- Open Source.

## The Why?

&nbsp;&nbsp;&nbsp;&nbsp;As an SRE myself, I've been working with API gateways for some time, wondering how to automate API life-cycle as a code. In my case, I have been working with Apigee X / Hybrid to manage, secure, monetize and monitor the full life-cycle of the APIs. I wanted to create CI/CD pipeline for API proxies as code.

&nbsp;&nbsp;&nbsp;&nbsp;Unfortunately I wasn't able to find good references for Azure DevOps pipelines implementation. So, I decided to work on a high quality pipeline code to help those struggling with a similar approach.

## Getting Started

- Create a GitHub repository for the framework

    ```bash
    GIT_URL='https://github.com/ORG/REPO.git'
    ```

    ```bash
    git clone https://github.com/ShehabEl-DeenAlalkamy/apigee-core-yaml-pipeline-templates.git
    cd apigee-core-yaml-pipeline-templates
    git init
    git remote add origin2 "${GIT_URL}"
    git checkout -b feature/cicd-framework
    git add .
    git commit -m "initial commit"
    git push -u origin2 feature/cicd-framework
    ```

- In your framework repository, update `build.yaml` and `release.yaml` `resources[0].endpoint` with a proper service connection.

- In your API proxy repository, create a `cicd/build.yaml` for your build pipeline and a `cicd/release.yaml` for your release pipeline.

- `cicd/build.yaml`:

    ```yaml
    resources:
        repositories:
          - repository: self
            clean: true
          - repository: {{ repository_identifier }} # an ID of your choice. for example: 'apigee-core'
            type: github
            name: {{ github_org }}/{{ created_or_forked_framework_repository }}
            ref: main
            endpoint: {{ service_connection }} # service connection created in your ADO project to access the repository

    extends:
      template: build.yaml@{{ repository_identifier }} # for example: build.yaml@apigee-core
      parameters:
        buildProfile: {{ build_profile }} # profile for building your API proxies, currently 'mvn-plugins' is the only supported value to build using Apigee Deploy & Apigee Config Maven Plugins
        variableGroups:
          - {{ common_variable_group }} # variable group for common variables across all environments, e.g gcpServiceAccount, org & proxyDesc
    ```
  
- `cicd/release.yaml`:
  
    ```yaml
    resources:
        repositories:
          - repository: self
            clean: true
          - repository: {{ repository_identifier }} # an ID of your choice. for example: 'apigee-core'
            type: github
            name: {{ github_org }}/{{ created_or_forked_framework_repository }}
            ref: main
            endpoint: {{ service_connection }} # service connection created in your ADO project to access the repository

    extends:
        template: release.yaml@{{ repository_identifier }} # for example: release.yaml@apigee-core
        parameters:
          releaseProfile: {{ release_profile }} # which Azure DevOps environments to deploy to, currently 'custom-release' is the only supported value
          deploymentProfile: {{ deployment_profile }} # how to deploy your API proxy, currently 'mvn-plugins' is the only supported value
          artifactAlias: {{ build_pipeline_resource_identifier }} # can be specified in resources.pipelines[0].pipeline
          artifactName: {{ proxy_bundle_artifact_name }} # by default it is named 'proxy-bundle-artifacts' in your build pipeline
          commonVariableGroups:
            - {{ common_variable_group }} # your common variables e.g gcpServiceAccount, org & proxyDesc
          releaseList: # required for 'custom-release' release profile, specify list of your deployment environments
            - stageName: {{ stage_name }} # identifier for you stage, for example 'Dev'
              displayName: {{ display_name }} # display name shown in your release pipeline run, for example 'Dev'
              variableGroup: {{ env_variable_group }} # your environment specific variables
              environment: {{ azure_devops_environment }} # your deployment environment
            ...
          apigeeConfigList: # required if deploymentConfig.customApigeeConfig is true, contains all the list of configurations you wish to create only regardless of source code
            - {{ apigee_config_item }} # supported values are [references, keystores, aliases, targetservers, keyvaluemaps, resourcefiles, apiproducts, developers, reports, flowhooks]
            ...
          deploymentConfig: # (optional) alters the deployment templates framework behavior
            customApigeeConfig: {{ true || false }} # enable/disable custom apigee configuration creation, default is false and will attempt to create all the supported configs
    ```

> :bulb: **Tip:** Refer to [abomis-airports][abomis-airports] for a full example.

<br />

## ⚔️ Developed By

<a href="https://www.linkedin.com/in/shehab-el-deen/" target="_blank"><img alt="LinkedIn" align="right" title="LinkedIn" height="24" width="24" src="docs/assets/imgs/linkedin.png"></a>

Shehab El-Deen Alalkamy

## :book: Author

Shehab El-Deen Alalkamy

<!--*********************  R E F E R E N C E S  *********************-->

<!-- * Links * -->

[apigee]: https://cloud.google.com/apigee/docs/api-platform/get-started/what-apigee
[apigee-api-proxy]: https://cloud.google.com/apigee/docs/api-platform/fundamentals/understanding-apis-and-api-proxies#:~:text=The%20Missing%20Link.-,What%20is%20an%20API%20proxy%3F,same%20API%20without%20any%20interruption.
[apigee-sf]: https://cloud.google.com/apigee/docs/api-platform/fundamentals/shared-flows
[apigee-kvm]: https://cloud.google.com/apigee/docs/api-platform/cache/key-value-maps#:~:text=maps%20(KVMs).-,Overview,encrypted%20key%2Fvalue%20String%20pairs.
[apigee-deploy-mvn]: https://github.com/apigee/apigee-deploy-maven-plugin
[apigee-config-mvn]: https://github.com/apigee/apigee-config-maven-plugin
[azure-pipelines]: https://azure.microsoft.com/en-us/services/devops/pipelines/
[abomis-airports]: https://github.com/ShehabEl-DeenAlalkamy/abomis-airports

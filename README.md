# blockchain-starter-kit

Hello! This GitHub repository contains a starter kit for building a blockchain application using the IBM Blockchain Platform. The starter kit includes everything you need for developing smart contracts, exposing them via RESTful APIs, and building end user applications. It also includes tooling that allows you to set up an IBM Cloud DevOps toolchain that will automatically deploy your blockchain application, and any future changes you make, to the IBM Cloud.

Follow the steps below to get started.

## 1. Setting up the local development environment

In order to use this starter kit, you will need to know how to develop blockchain applications. The IBM Blockchain Platform is built on open source technologies from the Linux Foundation Hyperledger Project, including Hyperledger Fabric and Hyperledger Composer.

We recommend that you set up your local developer environment following the Hyperledger Composer development tutorial available here: https://hyperledger.github.io/composer/latest/tutorials/developer-tutorial

The Hyperledger Composer development tutorial will teach you how to develop a smart contract, expose it via a RESTful API, and build an end user application. You will use these skills later on as part of the starter kit, so don't skip ahead!

## 2. Setting up the project and DevOps toolchain

To start building a blockchain application using this starter kit, you must first clone this GitHub repository into a new GitHub repository. You will then develop your blockchain application by working on the cloned GitHub repository. You do not need to manually clone this GitHub repository; please carry on reading!

You also want to set up a DevOps toolchain that will automatically build, test, and deploy your blockchain application to the IBM Cloud. The IBM Cloud DevOps service can be used to to run the DevOps toolchain, and this starter kit includes configuration suitable for use with the IBM Cloud DevOps service.

Click the following link to set up a DevOps toolchain for your blockchain application:

[Set up DevOps toolchain](https://console.bluemix.net/devops/setup/deploy/?repository=https%3A//github.com/sstone1/blockchain-starter-kit&branch=master&env_id=ibm%3Ayp%3Aus-south)

The "Create a Toolchain" page will appear:

![Toolchain initial screen](./media/toolchain-initial.png)

You must need to specify a name for your DevOps toolchain in the "Toolchain Name" field. In this example, I'll use "simons-blockchain-app" as the toolchain name:

![Toolchain name specified](./media/toolchain-name-specified.png)

Next, if you haven't authorized the IBM Cloud DevOps service to access your GitHub organization, you will see an "Authorize" button:

![Toolchain authorization required](./media/toolchain-auth-required.png)

You must click this button and authorize the IBM Cloud DevOps service to access your GitHub organization to continue. You will then see the following options:

![Toolchain authorization complete](./media/toolchain-auth-complete.png)

You must now specify a name for your clone of this GitHub repository. We recommend that you give it the same name that you used for the DevOps toolchain. In this example, I'll use "simons-blockchain-app" as the name of the cloned GitHub repository:

![Toolchain GitHub options specified](./media/toolchain-github-specified.png)

That's it! Click the "Create" button to create your new DevOps toolchain, and GitHub repository. You should be taken to your newly created DevOps toolchain page:

![Toolchain created](./media/toolchain-created.png)

The "GitHub" button in the middle will take you to your newly created GitHub repository. You will clone this GitHub repository into your local development environment, so you can work on your blockchain application.

The "Delivery Pipeline" button on the right will take you to the delivery pipeline for your DevOps toolchain. From here, you can inspect the output from the latest automated build and deployment of your blockchain application.

## 3. Cloning the GitHub repository

Click on the "GitHub" button to go to your newly created GitHub repository. If you are no longer on the DevOps toolchain page, you can find it by navigating to your GitHub organisation on [https://github.com](https://github.com).

![GitHub repository](./media/github-repo.png)

At the top of the page, you can see a link to the DevOps toolchain - useful if you have lost the link and need to find your way back!

Clone this GitHub repository to your local development environment using your favourite Git tool of choice. If you open this repository in an editor such as Visual Studio Code, you should see the following project structure:

![VSCode initial project structure](./media/vscode-initial.png)

## 4. Creating a smart contract

You can use the Yeoman plugin provided by Hyperledger Composer to create a skeleton smart contract for use in your blockchain application. You should have installed Yeoman and this plugin as part of the first step in this guide.

Using the command line, change into the `contracts` directory in your GitHub repository. Run Yeoman using `yo` to generate a skeleton smart contract in this directory. Ensure that you select the "Hyperledger Composer" generator, and then specify that you want to create a "Business Network" project.

In this example, I have created a smart contract called "simons-network":

![Yeoman business network](./media/yeoman-business-network.png)

You can work on this smart contract using your favourite editor, following the documentation on the Hyperledger Composer website.

The new smart contract will appear as pending changes in your GitHub repository. Add, commit, and push these changes into your GitHub repository. The DevOps toolchain you created earlier will detect these changes, and then automatically build, test, and deploy those changes to the IBM Cloud.

## 5. Checking the status of the DevOps toolchain

Navigate to the DevOps toolchain page, and click on the "Delivery Pipeline" button. You should see the following page, giving you an overview of the current status of your delivery pipeline:

![Delivery Pipeline overview](./media/delivery-pipeline-overview.png)

The delivery pipeline is made up of two phases, "BUILD" and "DEPLOY".

The "BUILD" phase of the delivery pipeline clones your GitHub repository, installs any dependencies, and runs all of the automated unit tests for all of your smart contracts. If any unit tests fail, then the delivery pipeline will fail and your changes will not be deployed.

The "DEPLOY" phase of the delivery pipeline deploys your smart contracts into the IBM Cloud. It is reponsible for provisioning and configuring an instance of the IBM Blockchain Platform: Starter Plan (the blockchain network), an instance of Cloudant (the wallet for blockchain credentials), deploying the smart contracts, and deploying RESTful API servers for each deployed smart contract.

If you click "View logs and history", you can see the latest logs for your build:

![Delivery Pipeline logs](./media/delivery-pipeline-logs.png)

Both "BUILD" and "DELIVERY" phases should be green and showing that no errors have occurred. If this is not the case, you must use the logs to investigate the cause of the errors.

## 6. Accessing the deployed REST server

The DevOps toolchain has automatically deployed a RESTful API server for each deployed smart contract. You can use these RESTful APIs to build end user applications that interact with a smart contract.

The URLs for the deployed RESTful API servers are available in the logs for the "DELIVERY" phase, but you can also find them in the [IBM Cloud Dashboard](https://console.bluemix.net/dashboard/apps). The RESTful API server is deployed as an application, with a name made up of "composer-rest-server-" and the name of the smart contract. In this example, the RESTful API server is called "composer-rest-server-simons-network":

![IBM Cloud Dashboard](./media/ibm-cloud-dashboard.png)

Click on the application in the list to navigate to the application details page:

![IBM Cloud RESTful API server application](./media/ibm-cloud-rest-app.png)

Click on the "Visit App URL" link at the top to navigate to the RESTful API explorer, that allows you to discover and try out the RESTful APIs for your deployed smart contract:

![RESTful API explorer](./media/rest-api-explorer.png)

## 7. Updating the deployed smart contract

Changes to deployed smart contracts will also be automatically deployed by the DevOps toolchain as well. You can test this by adding a new asset definition to a `.cto` file in your smart contract, for example:

```
asset SimonsAsset extends SampleAsset {

}
```

Add, commit, and push these changes into your GitHub repository. The DevOps toolchain you created earlier will detect these changes, and then automatically build, test, and deploy those changes to the IBM Cloud.

The RESTful API server will be automatically restarted as part of the deployment, and new RESTful APIs will be available for the new asset type that you have defined:

![Updated RESTful API explorer](./media/rest-api-updated.png)
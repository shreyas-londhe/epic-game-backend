# SHINOBI SHOWDOWN BACKEND

Destroy the Evil Shinobi with your own NFT Shinobi🥷

This is my project for the course [Create your own mini turn-based NFT browser game](https://app.buildspace.so/courses/CO5cc2751b-e878-41c4-99fa-a614dc910ee9) at [Buildspace](https://buildspace.so/).

Check the frontend code at https://github.com/shryasss/epic-game-frontend

## Prerequisites

- Node.js v14+

## Getting started

Follow the steps below to run the project locally:

- Install dependencies: `npm install`
- List test accounts from your local hardhat node: `npx hardhat accounts`
- Compile smart contracts: `npx hardhat compile`
- Test contract: `npx hardhat run scripts/run.js`

### Local deployment

- Start your local hardhat node: `npx hardhat node`
- Deploy contract to local hardhat node: `npx hardhat run scripts/deploy.js --network localhost`

### Testnet deployment

- Deploy contract to rinkeby testnet: `npx hardhat run scripts/deploy.js --network rinkeby`

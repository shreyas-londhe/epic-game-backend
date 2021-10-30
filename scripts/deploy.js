const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ['Naruto', 'Sasuke', 'Sakura'],
    [
      'QmZFCWjXVwjT5Jqz8P83KGxe3uYEmmsR5MPHgxh1mSLqnm',
      'QmUd3xdJDZFzZVmWtBG3cX2UFByDWXoLxbfwjj47dPe9bN',
      'QmeGAfWMcmrHM8QN9MEUUiCefjE3Qc43X3MaYMYTT5Wn5e',
    ],
    [10000, 9000, 5000],
    [100, 75, 20],
    'Zabuza',
    'QmYX8FDQ1yRwphVxL2nN752qEqp4UZDVoLyZrFyufMvXyc',
    100000,
    150
  );
  await gameContract.deployed();
  console.log('Contract deployed to:', gameContract.address);

  // let txn;
  // txn = await gameContract.mintCharacterNFT(1);
  // await txn.wait();
  // console.log('Minted NFT #1');

  // console.log('Done deploying and minting!');

  // txn = await gameContract.attackBoss();
  // await txn.wait();

  // txn = await gameContract.attackBoss();
  // await txn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();

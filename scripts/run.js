const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
  const gameContract = await gameContractFactory.deploy(
    ['Naruto', 'Sasuke', 'Sakura'],
    [
      'https://gateway.pinata.cloud/ipfs/QmZFCWjXVwjT5Jqz8P83KGxe3uYEmmsR5MPHgxh1mSLqnm',
      'https://gateway.pinata.cloud/ipfs/QmUd3xdJDZFzZVmWtBG3cX2UFByDWXoLxbfwjj47dPe9bN',
      'https://gateway.pinata.cloud/ipfs/QmeGAfWMcmrHM8QN9MEUUiCefjE3Qc43X3MaYMYTT5Wn5e',
    ],
    [10000, 9000, 5000],
    [100, 75, 20],
    'Zabuza',
    'https://gateway.pinata.cloud/ipfs/QmYX8FDQ1yRwphVxL2nN752qEqp4UZDVoLyZrFyufMvXyc',
    100000,
    150
  );
  await gameContract.deployed();
  console.log('Contract deployed to:', gameContract.address);

  let txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();

  // let returnedTokenURI = await gameContract.tokenURI(1);
  // console.log(`Token URI: ${returnedTokenURI}`);

  txn = await gameContract.attackBoss();
  await txn.wait();

  txn = await gameContract.attackBoss();
  await txn.wait();
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

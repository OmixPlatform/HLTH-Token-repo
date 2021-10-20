
async function deployV1() {
  console.log("------------------------------ Initial Setup Started ------------------------------");

  const hre = require("hardhat");

  console.log("------------------------------ Initial Setup Ended ------------------------------");

  console.log("------------------------------ Contract Deployment Ended ------------------------------");

  const C1 = await hre.ethers.getContractFactory("HLTHTokenv1");
  const c1Proxy = await hre.upgrades.upgradeProxy("0x46c8d00B7E72E98c64c44361A3e67A5E9102A3CA" , C1, { kind: "uups" });

  console.log("------------------------------ Contract Deployment Ended ------------------------------");

}

deployV1()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

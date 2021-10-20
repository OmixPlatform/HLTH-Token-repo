
async function deployBase() {
  console.log("------------------------------ Initial Setup Started ------------------------------");

  const hre = require("hardhat");
  let fs = require("fs");
  let deployedContractsv1 = require("../deployment/v1.json");

  const network = await hre.getChainId();
  deployedContractsv1[network] = {};

  console.log("------------------------------ Initial Setup Ended ------------------------------");

  console.log("--------------- Contract Deployment Started ---------------");

  const C1 = await hre.ethers.getContractFactory("HLTHToken");
  const c1Proxy = await hre.upgrades.deployProxy(C1, [ ], { kind: "uups" });
  console.log("Contract C1 deployed to: ", c1Proxy.address);

  console.log("------------------------------ Contract Deployment Ended ------------------------------");

  console.log("------------------------------ Configuration Started ------------------------------");

  // await c1Proxy.grantRole(
  //   "0x0000000000000000000000000000000000000000000000000000000000000000",
  //   "0xb00758D9EC6f83AE9188c60279461343dA237992",
  // );

  console.log("------------------------------ Configuration Ended ------------------------------");
  console.log("------------------------------ Deployment Storage Started ------------------------------");



  deployedContractsv1[network] = {
    C1: c1Proxy.address,
  };

  fs.writeFileSync("./deployment/v1.json", JSON.stringify(deployedContractsv1));

  console.log("------------------------------ Deployment Storage Ended ------------------------------");
}

deployBase()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

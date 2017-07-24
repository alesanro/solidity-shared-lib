var Owned = artifacts.require("./Owned.sol");

module.exports = function(deployer) {
  deployer.deploy(Owned)
  .then(() => console.log("[MIGRATION] [solidity-shared-lib] [1] Owned contract: #done"))
};

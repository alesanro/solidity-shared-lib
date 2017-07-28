var Owned = artifacts.require("Owned")
var Object = artifacts.require("Object")

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Owned)
  .then(() => deployer.deploy(Object))
  .then(() => console.log("[MIGRATION] [solidity-shared-lib] [1] Basic contracts: #done"))
};

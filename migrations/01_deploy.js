
const RoomFlow = artifacts.require("RoomFlow");

module.exports = function (deployer) {
  deployer.deploy(RoomFlow, 2, 1);  // You can pass the required constructor parameters here
};

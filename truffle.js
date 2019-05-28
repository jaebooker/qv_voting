var PrivateKeyProvider = require("truffle-privatekey-provider");
var rinkebyByPrivateKey = require("./config/secrets").rinkebyPrivateKey;
var rinkebyProvider = require("./config/secrets").rinekebyUrl;

module.exports = {
  networks: {
    dev: {
      host: 'localhost',
      port: 8545,
      network_id: "*",
      gas: 4500000
    },
    rinkeby: {
      provider: new PrivateKeyProvider(rinkebyByPrivateKey, rinkebyProvider),
      network_id: 4,
      gas: 4500000
    },
    private: {
      host: 'localhost',
      port: 8545,
      network_id: "*",
      gas: 4500000,
      from: "0x5d924b2d34643b4eb7d4291fdcb07236963f040f"
    }
  }
};
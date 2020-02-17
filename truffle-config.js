require('babel-register');
require('babel-polyfill');
const dotenv = require("dotenv");
dotenv.config();
const HDWalletProvider = require("@truffle/hdwallet-provider");
module.exports = {
    compilers: {
        solc: {
            version: "^0.5.0",
        },
    },
    networks: {
        mainnet: {
            provider: function() {
                return new HDWalletProvider(process.env.KEY_MAIN, "https://mainnet.infura.io/v3/" + process.env.INFURA_KEY)
            },
            network_id: 1
        },
        ropsten: {
            provider: function() {
                return new HDWalletProvider(process.env.KEY_TEST, "https://ropsten.infura.io/v3/" + process.env.INFURA_KEY)
            },
            network_id: 3,
            skipDryRun: true,
        },
        ganache: {
            provider: function() {
                return new HDWalletProvider(process.env.KEY_TEST, "http://127.0.0.1:8545")
            },
            network_id: 4,
            skipDryRun: true,
        }
    }
};

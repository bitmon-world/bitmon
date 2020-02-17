const Contract = artifacts.require("./contracts/BitmonCore.sol");
Contract.numberFormat = 'String';

contract("BitmonCore", async (accounts) => {
    it("the first account should be able to mint", async () => {
        let c = await Contract.deployed();
        let minter = await c.isMinter.call(accounts[0]);
        assert.equal(minter, true);
    });

    it("the first account should own 0 token", async () => {
        let c = await Contract.deployed();
        let tokens = await c.balanceOf.call(accounts[0]);
        assert.equal(tokens, "0");
    });

    it("set random source contract", async () => {
        let c = await Contract.deployed();
        await c.setRandomContractAddr("0x6E57869E9cD5c4dB8f47534a961bbb7c1e23d3FC");
    });

    it("mint 1 bitmon to 0 address", async () => {
        let c = await Contract.deployed();
        await c.mintBitmon(accounts[0], 1,1,1,1,1);
    });

    it("other accounts should not contain tokens", async () => {
        let c = await Contract.deployed();
        let tokensFirst = await c.balanceOf.call(accounts[1]);
        assert.equal(tokensFirst, "0");
        let tokensSecond = await c.balanceOf.call(accounts[2]);
        assert.equal(tokensSecond, "0");
        let tokensThird = await c.balanceOf.call(accounts[3]);
        assert.equal(tokensThird, "0");
        let tokensFourth = await c.balanceOf.call(accounts[4]);
        assert.equal(tokensFourth, "0");
        let tokensFifth = await c.balanceOf.call(accounts[5]);
        assert.equal(tokensFifth, "0");
    });

    it("test transfer between accounts without privileges", async () => {
        let c = await Contract.deployed();
        await c.transferFrom(accounts[0], accounts[1], 1);

        // Test index with transfer information
        let balanceSend = await c.balanceOf(accounts[0]);
        assert.equal(balanceSend, "0");
        let balanceReceived = await c.balanceOf(accounts[1]);
        assert.equal(balanceReceived, "1");
    });

    it("all other accounts should be unable to mint", async () => {
        let c = await Contract.deployed();
        let minter;
        minter = await c.isMinter.call(accounts[1]);
        assert.equal(minter, false);
        minter = await c.isMinter.call(accounts[2]);
        assert.equal(minter, false);
        minter = await c.isMinter.call(accounts[3]);
        assert.equal(minter, false);
        minter = await c.isMinter.call(accounts[4]);
        assert.equal(minter, false);
        minter = await c.isMinter.call(accounts[5]);
        assert.equal(minter, false);
    });

    it("total supply should be 1", async () => {
        let c = await Contract.deployed();
        let supply = await c.totalSupply.call();
        assert.equal(supply, "1");
    });

    it("get bitmon data", async () => {
        let c = await Contract.deployed();
        await c.bitmonData("1");
    });

});

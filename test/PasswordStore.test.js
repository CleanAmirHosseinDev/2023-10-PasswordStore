const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PasswordStore", function () {
  let PasswordStore, passwordStore, owner, addr1;

  beforeEach(async function () {
    PasswordStore = await ethers.getContractFactory("PasswordStore");
    [owner, addr1] = await ethers.getSigners();
    passwordStore = await PasswordStore.deploy();
    await passwordStore.deployed();
  });

  it("Owner can set password", async function () {
    await passwordStore.setPassword("mySecret");
    expect(await passwordStore.checkPassword("mySecret")).to.equal(true);
  });

  it("Non-owner cannot set password", async function () {
    await expect(
      passwordStore.connect(addr1).setPassword("hack")
    ).to.be.revertedWith("PasswordStore__NotOwner");
  });

  it("Non-owner cannot check password", async function () {
    await expect(
      passwordStore.connect(addr1).checkPassword("mySecret")
    ).to.be.revertedWith("PasswordStore__NotOwner");
  });
});

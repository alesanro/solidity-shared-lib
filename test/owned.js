const Owned = artifacts.require("./Owned.sol")

contract("Owned", function (accounts) {
    const owner1 = accounts[0]
    const owner2 = accounts[1]
    const owner3 = accounts[2]

    let owned

    before("setup", function(done) {
        Owned.deployed()
        .then((result) => owned = result)
        .then(() => done())
        .catch((e) => done(e))
    })

    it("contract owner should be a message sender", function() {
        return owned.contractOwner().then((r) => {
            assert.equal(r, owner1)
        })
    })

    it("should not be allowed to change ownership by non-owner", function() {
        return owned.changeContractOwnership.call(owner2, {from: owner2}).then((r) => {
            return owned.changeContractOwnership(owner2, {from: owner2}).then(() => {
                assert.equal(r, 0)
            })
        })
    })

    it("should be allowed to change ownership by an owner", function() {
        return owned.changeContractOwnership.call(owner2, {from: owner1}).then((r) => {
            return owned.changeContractOwnership(owner2, {from: owner1}).then(() => {
                assert.equal(r, 1)
                return owned.pendingContractOwner()
            }).then((r) => {
                assert.equal(r, owner2)
            })
        })
    })

    it("should not be allowed to claim ownership by future non-owner", function() {
        return owned.claimContractOwnership.call({from: owner3}).then((r) => {
            return owned.claimContractOwnership({from: owner3}).then(() => {
                assert.equal(r, 0)
            })
        })
    })

    it("should be allowed to claim ownership by future owner", function() {
        return owned.claimContractOwnership.call({from: owner2}).then((r) => {
            return owned.claimContractOwnership({from: owner2}).then(() => {
                assert.equal(r, 1)
                return owned.pendingContractOwner()
            }).then((r) => {
                assert.equal(r, 0)
                return owned.contractOwner()
            }).then((r) => {
                assert.equal(r, owner2)
            })
        })
    })
})

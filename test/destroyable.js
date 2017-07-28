const Object = artifacts.require("Object")


contract("Object(and destroyable)", function(accounts) {
    const owner = accounts[0]
    const futureOwner = accounts[1]
    const nonowner = accounts[2]

    let obj

    before("setup", function(done) {
        Object.deployed().then(instance => obj = instance)
        .then(() => done())
        .catch(e => done(e))
    })

    it("cannot change 'hammer' by non-owner", function() {
        return obj.setHammer(nonowner, {from: nonowner}).then(assert.fail).catch(() => {})
        .then(() => obj.hammer())
        .then(hammer => {
            assert.equal(hammer, owner)
        })
    })

    it("can change 'hammer' by owner", function() {
        return obj.setHammer(futureOwner).then(() => obj.hammer())
        .then(hammer => {
            assert.equal(hammer, futureOwner)
        })
    })

    it("non-owner should not be able to destroy contract", function() {
        return obj.destroy({from: nonowner}).then(assert.fail).catch(() => {})
    })

    it("owner should be able to destoy contract", function() {
        const hammer = futureOwner
        return obj.destroy({from: hammer}).catch(assert.fail)
    })
})

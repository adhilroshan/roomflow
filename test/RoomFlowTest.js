const { assert } = require("chai");

const RoomFlow = artifacts.require("RoomFlow");

contract("RoomFlow", (accounts) => {
    let roomFlowInstance;

    before(async () => {
        roomFlowInstance = await RoomFlow.deployed();
    });

    describe("Creating and Updating Spaces", () => {
        it("should create a new space", async () => {
            await roomFlowInstance.createSpace("Space 1", "Description", "Images", 2, web3.utils.toWei("1", "ether"));
            const space = await roomFlowInstance.getSpace(1);
            assert.equal(space.name, "Space 1", "Space name does not match");
        });

        it("should not create a space with zero price", async () => {
            try {
                await roomFlowInstance.createSpace("Space 2", "Description", "Images", 2, 0);
                assert.fail("Should have thrown an error");
            } catch (error) {
                assert.include(error.message, "Price cannot be zero", "Wrong error message");
            }
        });

        it("should update a space", async () => {
            await roomFlowInstance.updateSpace(1, "Updated Space", "Updated Description", "Updated Images", 3, web3.utils.toWei("2", "ether"));
            const space = await roomFlowInstance.getSpace(1);
            assert.equal(space.name, "Updated Space", "Space name not updated");
        });

        it("should not update a space if not the owner", async () => {
            try {
                await roomFlowInstance.updateSpace(1, "Attempt Update", "Attempt Description", "Attempt Images", 4, web3.utils.toWei("3", "ether"), { from: accounts[1] });
                assert.fail("Should have thrown an error");
            } catch (error) {
                assert.include(error.message, "Unauthorized personnel, owner only", "Wrong error message");
            }
        });
    });

    describe("Booking and Refunding Spaces", () => {
        it("should book a space and refund if cancelled", async () => {
            await roomFlowInstance.createSpace("Space 3", "Description", "Images", 2, web3.utils.toWei("1", "ether"));
            await roomFlowInstance.bookSpace(2, 1, 3, { value: web3.utils.toWei("3", "ether") });
            await roomFlowInstance.refundBooking(2, 0, 1);
            const booking = await roomFlowInstance.getBooking(2, 0);
            assert.equal(booking.cancelled, true, "Booking not cancelled");
        });

        // Add more booking and refunding test cases here
    });

    describe("Checking in Spaces", () => {
        it("should check in a space", async () => {
            await roomFlowInstance.createSpace("Space 4", "Description", "Images", 2, web3.utils.toWei("1", "ether"));
            await roomFlowInstance.bookSpace(3, 4, 6, { value: web3.utils.toWei("3", "ether") });
            await roomFlowInstance.checkInSpace(3, 0);
            const booking = await roomFlowInstance.getBooking(3, 0);
            assert.equal(booking.checked, true, "Space not checked in");
        });

        // Add more checking-in test cases here
    });

    describe("Adding and Getting Reviews", () => {
        it("should add a review for a space", async () => {
            await roomFlowInstance.createSpace("Space 5", "Description", "Images", 2, web3.utils.toWei("1", "ether"));
            await roomFlowInstance.bookSpace(4, 7, 9, { value: web3.utils.toWei("3", "ether") });
            await roomFlowInstance.checkInSpace(4, 0);
            await roomFlowInstance.addReview(4, "Great space!");
            const reviews = await roomFlowInstance.getReviews(4);
            assert.equal(reviews.length, 1, "Review not added");
        });

        // Add more review-related test cases here
    });

    describe("Getting Space Details", () => {
        it("should get details of a space", async () => {
            await roomFlowInstance.createSpace("Space 6", "Description", "Images", 2, web3.utils.toWei("1", "ether"));
            const space = await roomFlowInstance.getSpace(5);
            assert.equal(space.name, "Space 6", "Space details not retrieved");
        });

        // Add more space details retrieval test cases here
    });

    // Add more test cases as needed
});

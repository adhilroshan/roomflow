    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/access/Ownable.sol";
    import "@openzeppelin/contracts/utils/Counters.sol";
    import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

    contract RoomFlow is Ownable, ReentrancyGuard {
        using Counters for Counters.Counter;
        Counters.Counter private _totalSpaces;
        Counters.Counter private _totalReviews;

        struct SpaceListing {
            uint id;
            string name;
            string description;
            string images;
            uint rooms;
            uint price;
            address owner;
            bool booked;
            bool deleted;
            bool availability;
            uint timestamp;
        }

        struct Booking {
            uint id;
            address tenant;
            uint startDate;
            uint endDate;
            uint totalPrice;
            bool checked;
            bool cancelled;
        }

        struct Review {
            uint id;
            uint spaceId;
            string reviewText;
            uint timestamp;
            address reviewer;
        }

        // event SecurityFeeUpdated(uint newFee);

        event SpaceListed(uint indexed id, address indexed owner);
        event SpaceUpdated(uint indexed id, address indexed owner);
        event SpaceDeleted(uint indexed id, address indexed owner);
        event SpaceBooked(
            uint indexed id,
            address indexed tenant,
            uint startDate,
            uint endDate
        );
        event SpaceCheckedIn(
            uint indexed id,
            address indexed tenant,
            uint bookingId
        );
        event SpaceFundsClaimed(
            uint indexed id,
            address indexed owner,
            uint bookingId
        );
        event SpaceRefunded(
            uint indexed id,
            address indexed tenant,
            uint bookingId
        );
        event ReviewAdded(uint indexed spaceId, address indexed author);
        event SecurityFeeUpdated(uint newFee);
        event TaxPercentUpdated(uint newTaxPercent);

        uint public securityFee;
        uint public taxPercent;

        mapping(uint => SpaceListing) public spaces;
        mapping(uint => Booking[]) public bookingsOf;
        mapping(uint => Review[]) public reviewsOf;
        mapping(uint => bool) public spaceExists;
        mapping(uint => uint[]) public bookedDates;
        mapping(uint => mapping(uint => bool)) public isDateBooked;
        mapping(address => mapping(uint => bool)) public hasBooked;

        constructor(uint _taxPercent, uint _securityFee) {
            taxPercent = _taxPercent;
            securityFee = _securityFee;
        }

        function createSpace(
            string memory name,
            string memory description,
            string memory images,
            uint rooms,
            uint price
        ) public {
            require(bytes(name).length > 0, "Name cannot be empty");
            require(bytes(description).length > 0, "Description cannot be empty");
            require(bytes(images).length > 0, "Images cannot be empty");
            require(rooms > 0, "Rooms cannot be zero");
            require(price > 0 ether, "Price cannot be zero");

            _totalSpaces.increment();
            SpaceListing memory space;
            space.id = _totalSpaces.current();
            space.name = name;
            space.description = description;
            space.images = images;
            space.rooms = rooms;
            space.price = price;
            space.owner = msg.sender;
            space.availability = true;
            space.timestamp = block.timestamp;

            spaceExists[space.id] = true;
            spaces[space.id] = space;
            emit SpaceListed(space.id, msg.sender);
        }

        function updateSpace(
            uint id,
            string memory name,
            string memory description,
            string memory images,
            uint rooms,
            uint price
        ) public {
            require(spaceExists[id], "Space not available");
            require(
                msg.sender == spaces[id].owner,
                "Unauthorized personnel, owner only"
            );
            require(bytes(name).length > 0, "Name cannot be empty");
            require(bytes(description).length > 0, "Description cannot be empty");
            require(bytes(images).length > 0, "Images cannot be empty");
            require(rooms > 0, "Rooms cannot be zero");
            require(price > 0 ether, "Price cannot be zero");

            SpaceListing memory space = spaces[id];
            space.name = name;
            space.description = description;
            space.images = images;
            space.rooms = rooms;
            space.price = price;

            spaces[id] = space;
            emit SpaceUpdated(id, msg.sender);
        }

        function deleteSpace(uint id) public {
            require(spaceExists[id], "Space not available");
            require(spaces[id].owner == msg.sender, "Unauthorized entity");

            spaceExists[id] = false;
            spaces[id].deleted = true;
            emit SpaceDeleted(id, msg.sender);
        }

        function getSpaces() public view returns (SpaceListing[] memory) {
            uint256 totalSpace;
            for (uint i = 1; i <= _totalSpaces.current(); i++) {
                if (!spaces[i].deleted) totalSpace++;
            }

            SpaceListing[] memory spaceListings = new SpaceListing[](totalSpace);

            uint256 j = 0;
            for (uint i = 1; i <= _totalSpaces.current(); i++) {
                if (!spaces[i].deleted) {
                    spaceListings[j] = spaces[i];
                    j++;
                }
            }

            return spaceListings;
        }

        function getSpace(uint id) public view returns (SpaceListing memory) {
            return spaces[id];
        }

        function bookSpace(
            uint id,
            uint startDate,
            uint endDate
        ) public payable nonReentrant {
            require(spaceExists[id], "Space not available");
            require(
                msg.value >=
                    spaces[id].price * (endDate - startDate + 1) + securityFee,
                "Insufficient fund"
            );
            require(
                isDateCleared(id, startDate, endDate),
                "Booked date found among dates"
            );

            for (uint i = startDate; i <= endDate; i++) {
                Booking memory booking;
                booking.id = bookingsOf[id].length;
                booking.tenant = msg.sender;
                booking.startDate = startDate;
                booking.endDate = endDate;
                booking.totalPrice = spaces[id].price * (endDate - startDate + 1);
                bookingsOf[id].push(booking);
                isDateBooked[id][i] = true;
                bookedDates[id].push(i);
            }
            emit SpaceBooked(id, msg.sender, startDate, endDate);
        }

        function isDateCleared(
            uint id,
            uint startDate,
            uint endDate
        ) internal view returns (bool) {
            for (uint i = startDate; i <= endDate; i++) {
                if (isDateBooked[id][i]) return false;
            }
            return true;
        }

        function checkInSpace(uint id, uint bookingId) public {
            require(
                msg.sender == bookingsOf[id][bookingId].tenant,
                "Unauthorized tenant"
            );
            require(
                !bookingsOf[id][bookingId].checked,
                "Apartment already checked on this date"
            );

            bookingsOf[id][bookingId].checked = true;
            uint price = bookingsOf[id][bookingId].totalPrice;
            uint fee = (price * taxPercent) / 100;

            hasBooked[msg.sender][id] = true;

            payTo(spaces[id].owner, (price - fee));
            payTo(owner(), fee);
            payTo(msg.sender, securityFee);
            emit SpaceCheckedIn(id, msg.sender, bookingId);
        }

        function claimFunds(uint id, uint bookingId) public {
            require(msg.sender == spaces[id].owner, "Unauthorized entity");
            require(
                !bookingsOf[id][bookingId].checked,
                "Apartment already checked on this date"
            );

            uint price = bookingsOf[id][bookingId].totalPrice;
            uint fee = (price * taxPercent) / 100;

            payTo(spaces[id].owner, (price - fee));
            payTo(owner(), fee);
            payTo(msg.sender, securityFee);
            emit SpaceFundsClaimed(id, msg.sender, bookingId);
        }

        function refundBooking(
            uint id,
            uint bookingId,
            uint date
        ) public nonReentrant {
            require(
                !bookingsOf[id][bookingId].checked,
                "Apartment already checked on this date"
            );

            if (msg.sender != owner()) {
                require(
                    msg.sender == bookingsOf[id][bookingId].tenant,
                    "Unauthorized tenant"
                );
                require(
                    bookingsOf[id][bookingId].startDate > block.timestamp,
                    "Can no longer refund, booking date started"
                );
            }

            bookingsOf[id][bookingId].cancelled = true;
            isDateBooked[id][date] = false;

            uint lastIndex = bookedDates[id].length - 1;
            uint lastBookingId = bookedDates[id][lastIndex];
            bookedDates[id][bookingId] = lastBookingId;
            bookedDates[id].pop();

            uint price = bookingsOf[id][bookingId].totalPrice;
            uint fee = (securityFee * taxPercent) / 100;

            payTo(spaces[id].owner, (securityFee - fee));
            payTo(owner(), fee);
            payTo(msg.sender, price);
            emit SpaceRefunded(id, msg.sender, bookingId);
        }

        function hasBookedDateReached(
            uint id,
            uint bookingId
        ) public view returns (bool) {
            return bookingsOf[id][bookingId].startDate < block.timestamp;
        }

        function getUnavailableDates(uint id) public view returns (uint[] memory) {
            return bookedDates[id];
        }

        function getBookings(uint id) public view returns (Booking[] memory) {
            return bookingsOf[id];
        }

        function getBooking(
            uint id,
            uint bookingId
        ) public view returns (Booking memory) {
            return bookingsOf[id][bookingId];
        }

        function updateSecurityFee(uint newFee) public onlyOwner {
            require(newFee > 0, "Fee must be greater than 0");
            securityFee = newFee;
            emit SecurityFeeUpdated(newFee);
        }

        function updateTaxPercent(uint newTaxPercent) public onlyOwner {
            taxPercent = newTaxPercent;
        }

        function addReview(uint spaceId, string memory reviewText) public {
            require(spaceExists[spaceId], "Space not available");
            require(hasBooked[msg.sender][spaceId], "Book first before review");
            require(bytes(reviewText).length > 0, "Review text cannot be empty");

            _totalReviews.increment();
            Review memory review;
            review.id = _totalReviews.current();
            review.spaceId = spaceId;
            review.reviewText = reviewText;
            review.timestamp = block.timestamp;
            review.reviewer = msg.sender;

            reviewsOf[spaceId].push(review);
            emit ReviewAdded(spaceId, msg.sender);
        }

        function getReviews(uint spaceId) public view returns (Review[] memory) {
            return reviewsOf[spaceId];
        }

        function tenantBooked(uint spaceId) public view returns (bool) {
            return hasBooked[msg.sender][spaceId];
        }

        function currentTime() internal view returns (uint256) {
            uint256 newNum = (block.timestamp * 1000) + 1000;
            return newNum;
        }

        function payTo(address to, uint256 amount) internal {
            (bool success, ) = payable(to).call{value: amount}("");
            require(success, "Payment failed");
        }
    }

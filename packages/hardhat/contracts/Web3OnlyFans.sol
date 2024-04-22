// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Web3OnlyFans
 * @dev A smart contract for a Web3 onlyfans platform with NFT badges for subscribers
 */
contract Web3OnlyFans is ERC721Enumerable, Ownable {
    // Mapping to track the subscribers of each creator
    mapping(address => mapping(uint256 => bool)) private _subscribers;

    // Mapping to track the subscription level of each subscriber
    mapping(address => mapping(uint256 => uint256)) private _subscriptionLevels;

    // Event to log when a creator is subscribed by a subscriber
    event Subscribed(address indexed subscriber, uint256 indexed creatorId);

    // Event to log when a subscriber unsubscribes from a creator
    event Unsubscribed(address indexed subscriber, uint256 indexed creatorId);

    // Event to log when a subscriber's subscription level changes
    event SubscriptionLevelChanged(address indexed subscriber, uint256 indexed creatorId, uint256 level);

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    /**
     * @dev Function to subscribe to a creator
     * @param creatorId The ID of the creator to subscribe to
     * @param level The subscription level of the subscriber
     */
    function subscribe(uint256 creatorId, uint256 level) external {
        require(!_subscribers[msg.sender][creatorId], "Already subscribed");
        
        _subscribers[msg.sender][creatorId] = true;
        _subscriptionLevels[msg.sender][creatorId] = level;
        emit Subscribed(msg.sender, creatorId);
        emit SubscriptionLevelChanged(msg.sender, creatorId, level);
    }

    /**
     * @dev Function to unsubscribe from a creator
     * @param creatorId The ID of the creator to unsubscribe from
     */
    function unsubscribe(uint256 creatorId) external {
        require(_subscribers[msg.sender][creatorId], "Not subscribed");
        
        delete _subscribers[msg.sender][creatorId];
        delete _subscriptionLevels[msg.sender][creatorId];
        emit Unsubscribed(msg.sender, creatorId);
        emit SubscriptionLevelChanged(msg.sender, creatorId, 0);
    }

    /**
     * @dev Function to check if a subscriber is subscribed to a creator
     * @param subscriber The address of the subscriber
     * @param creatorId The ID of the creator
     * @return true if subscriber is subscribed to the creator, false otherwise
     */
    function isSubscribed(address subscriber, uint256 creatorId) external view returns (bool) {
        return _subscribers[subscriber][creatorId];
    }

    /**
     * @dev Function to get the subscription level of a subscriber to a creator
     * @param subscriber The address of the subscriber
     * @param creatorId The ID of the creator
     * @return the subscription level of the subscriber
     */
    function getSubscriptionLevel(address subscriber, uint256 creatorId) external view returns (uint256) {
        return _subscriptionLevels[subscriber][creatorId];
    }
}
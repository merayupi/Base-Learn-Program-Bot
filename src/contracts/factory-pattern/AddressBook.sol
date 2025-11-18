// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    // Custom error for contact not found
    error ContactNotFound(uint256 id);
    
    // Contact struct
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }
    
    // Storage for contacts
    mapping(uint256 => Contact) private contacts;
    uint256[] private contactIds;
    uint256 private nextId = 1;
    
    constructor(address _owner) Ownable(_owner) {}
    
    // Add contact (only owner)
    function addContact(
        string memory _firstName,
        string memory _lastName,
        uint256[] memory _phoneNumbers
    ) external onlyOwner {
        uint256 contactId = nextId;
        
        contacts[contactId] = Contact({
            id: contactId,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });
        
        contactIds.push(contactId);
        nextId++;
    }
    
    // Delete contact (only owner)
    function deleteContact(uint256 _id) external onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        
        // Remove from contacts mapping
        delete contacts[_id];
        
        // Remove from contactIds array
        for (uint256 i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }
    
    // Get specific contact (public access)
    function getContact(uint256 _id) external view returns (Contact memory) {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }
    
    // Get all contacts (public access)
    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        
        for (uint256 i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        
        return allContacts;
    }
}

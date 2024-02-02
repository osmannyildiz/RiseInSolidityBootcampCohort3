// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    struct Proposal {
        string title;
        string description;
        uint256 approve_count;
        uint256 reject_count;
        uint256 pass_count;
        uint256 total_vote_count_to_end;
        bool current_state; // whether it passes of fails
        bool is_active;
    }

    address owner;
    mapping(uint256 => Proposal) proposals;
    uint256 private proposal_counter;
    address[] private voted_addresses;

    modifier onlyOwner() {
        require(msg.sender == owner, "This function can be executed only by the owner.");
        _;
    }

    modifier requireCurrentProposalIsActive() {
        require(proposals[proposal_counter].is_active, "The current proposal is not active.");
        _;
    }

    // TODO
    modifier requireHasNotVotedBefore(address _address) {
        // require(!hasVoted(_address), "Address has already voted.");
        _;
    }

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender);
    }

    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function createProposal(
        string calldata _title,
        string calldata _description,
        uint256 _total_vote_count_to_end
    ) external onlyOwner {
        proposal_counter += 1;
        proposals[proposal_counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_count_to_end, false, true);
    }

    function voteOnCurrentProposal(uint8 choice) external requireCurrentProposalIsActive requireHasNotVotedBefore(msg.sender) {
        require(choice >= 1 && choice <= 3, "Choice must be between 1 and 3.");

        Proposal storage proposal = proposals[proposal_counter];
        
        if (choice == 1) {
            proposal.approve_count += 1;
        } else if (choice == 2) {
            proposal.reject_count += 1;
        } else { // choice == 3
            proposal.pass_count += 1;
        }
        voted_addresses.push(msg.sender);
        
        proposal.current_state = calculateProposalCurrentState();

        uint256 total_vote_count = proposal.approve_count + proposal.reject_count + proposal.pass_count;
        if (total_vote_count == proposal.total_vote_count_to_end) {
            proposal.is_active = false;
            voted_addresses = [owner];
        }
    }

    /*
      - For a proposal to succeed, the number of approve votes should be higher than the sum of reject and half the pass votes
        (you can think like pass votes have half the impact).
      - You may have an odd number of pass votes which cannot be divided by two. In these cases, you add 1 to the number of
        pass votes and then divide.
    */
    function calculateProposalCurrentState() private view returns (bool) {
        Proposal storage proposal = proposals[proposal_counter];

        uint256 approve = proposal.approve_count;
        uint256 reject = proposal.reject_count;
        uint256 pass = proposal.pass_count;
            
        if (pass % 2 == 1) {
            pass += 1;
        }

        pass = pass / 2;

        if (approve > reject + pass) {
            return true; // passed
        } else {
            return false; // failed
        }
    }
}

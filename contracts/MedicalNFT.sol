// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MedicalNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Test {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string reason;
        string diagnosis;
        bool followUp;
        string nextSteps;
        string imageHash;
    }

    struct Scan {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string reason;
        string diagnosis;
        bool followUp;
        string nextSteps;
        string imageHash;
    }

    struct XRay {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string reason;
        string diagnosis;
        bool followUp;
        string nextSteps;
        string imageHash;
    }

    struct SurgicalProcedure {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string reason;
        string diagnosis;
        bool followUp;
        string nextSteps;
        string afterCare;
        string imageHash;
    }

    struct Vaccination {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string imageHash;
    }

    struct Report {
        uint patientId;
        string govMedicalDID;
        uint date;
        string title;
        string details;
        string imageHash;
    }

    address public owner;

    Test[] public tests;
    Scan[] public scans;
    XRay[] public xrays;
    SurgicalProcedure[] public surgicalProcedures;
    Vaccination[] public vaccinations;
    Report[] public reports;

    event TestResult(uint patientId);
    event ScanResult(uint patientId);
    event XrayResult(uint patientId);
    event SurgeryResult(uint patientId);
    event VaccinationCompleted(uint patientId);
    event ReportIssued(uint patientId);
     
    constructor(
        string memory tokenName, 
        string memory symbol
        ) ERC721(
            "MedicalReport", 
            "MED"
            ) {
        _setBaseURI("ipfs://");
        owner = msg.sender;
    }
     
    /**
    @dev The owner is the medical professional.
     */
    function mintTokenOfMedicalIPFSFile(address owner, string patientId, string memory metadataURI)
    public
    returns (uint)
    {
        _tokenIds.increment();

        uint patientId = _tokenIds.current();
        _safeMint(msg.sender, patientId);
        _setTokenURI(patientId, metadataURI);

        return patientId;
    }
   
    function addTestResult(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,
        string _reason,
        string _diagnosis,
        bool _followUp,
        string _nextSteps,
        string _imageHash
    )public {
        Test memory t;
        t.patientId = _patientId;
        t.govMedicalDID = _govMedicalDID;
        t.date = _date;
        t.title = _title;
        t.reason = _reason;
        t.diagnosis = _diagnosis;
        t.followUp = _followUp;
        t.nextSteps = _nextSteps;
        t.imageHash = _imageHash;
        tests.push(t);
        emit TestResult(msg.sender, _patientId);
        }

        function addScanResult(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,
        string _reason,
        string _diagnosis,
        bool _followUp,
        string _nextSteps,
        string _imageHash
    )public {
        Scan memory s;
        s.patientId = _patientId;
        s.govMedicalDID = _govMedicalDID;
        s.date = _date;
        s.title = _title;
        s.reason = _reason;
        s.diagnosis = _diagnosis;
        s.followUp = _followUp;
        s.nextSteps = _nextSteps;
        s.imageHash = _imageHash;
        scans.push(s);
        emit ScanResult(msg.sender, _patientId);
        }

        function addXrayResult(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,
        string _reason,
        string _diagnosis,
        bool _followUp,
        string _nextSteps,
        string _imageHash
    )public {
        Xray memory x;
        x.patientId = _patientId;
        x.govMedicalDID = _govMedicalDID;
        x.date = _date;
        x.title = _title;
        x.reason = _reason;
        x.diagnosis = _diagnosis;
        x.followUp = _followUp;
        x.nextSteps = _nextSteps;
        x.imageHash = _imageHash;
        tests.push(x);
        emit XrayResult(msg.sender, _patientId);
        }

        function addSurgeryResult(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,
        string _reason,
        string _diagnosis,
        bool _followUp,
        string _nextSteps,
        string _afterCare,
        string _imageHash 
    )public {
        SurgicalProcedure memory sp;
        sp.patientId = _patientId;
        sp.govMedicalDID = _govMedicalDID;
        sp.date = _date;
        sp.title = _title;
        sp.reason = _reason;
        sp.diagnosis = _diagnosis;
        sp.followUp = _followUp;
        sp.nextSteps = _nextSteps;
        sp.afterCare = _afterCare;
        sp.imageHash = _imageHash;
        surgicalProcedures.push(sp);
        emit SurgeryResult(msg.sender, _patientId);
        }

        function addVaccination(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,  
        string _imageHash
    )public {
        Vaccination memory v;
        v.patientId = _patientId;
        v.govMedicalDID = _govMedicalDID;
        v.date = _date;
        v.title = _title;
        v.imageHash = _imageHash;
        vaccinations.push(v);
        emit VaccinationCompleted(msg.sender, _patientId);
        }

        function addReport(
        uint _patientId,
        string _govMedicalDID,
        uint _date,
        string _title,
        string _details,
        string _imageHash
    )public {
        Report memory r;
        r.patientId = _patientId;
        r.govMedicalDID = _govMedicalDID;
        r.date = _date;
        r.title = _title;
        r.details = _details;
        r.imageHash = _imageHash;
        reports.push(r);
        emit ReportIssued(msg.sender, _patientId);
        }
    }               
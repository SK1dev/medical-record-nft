// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicalRecord {
    
    struct Patients{
        uint id;
        string govMedicalDID;
        uint phone;
        string gender;
        uint dob;
        uint height;
        uint weight;
        string bloodGroup;
        string allergies;
        string medication;
        address addr;
        uint date;
    }

    struct Doctors{
        uint id;
        string name;
        uint phone;
        string gender;
        uint dob;
        string qualifications;
        address addr;
        uint date;
    }

    struct Appointments{
        address doctorAddr;
        address patientAddr;
        uint date;
        uint time;
        string prescription;
        string description;
        string diagnosis;
        string status;
        uint creationDate;
    }
    
    address public owner;
    address[] public patientList;
    address[] public doctorList;
    address[] public appointmentList;

    mapping(address => Patients) patients;
    mapping(address => Doctors) doctors;
    mapping(address => Appointments) appointments;

    mapping(address=>mapping(address=>bool)) isApproved;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;
    mapping(address => uint) AppointmentPerPatient;

    uint public patientCount = 0;
    uint public doctorCount = 0;
    uint public appointmentCount = 0;
    uint public permissionGrantedCount = 0;
    
    constructor() {
        owner = msg.sender;
    }
    
    function setPatientDetails(
        uint _id, 
        string memory _govMedicalDID, 
        uint _phone, 
        string memory _gender, 
        uint _dob, 
        uint _height, 
        uint _weight,  
        string memory _bloodGroup, 
        string memory _allergies, 
        string memory _medication
        ) public {
        require(!isPatient[msg.sender]);
        Patients storage p = patients[msg.sender];
        
        p.id = _id;
        p.govMedicalDID = _govMedicalDID;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.height = _height; 
        p.weight = _weight;
        p.bloodGroup = _bloodGroup;
        p.allergies = _allergies;
        p.medication = _medication;
        p.addr = msg.sender;
        p.date = block.timestamp;
        
        patientList.push(msg.sender);
        isPatient[msg.sender] = true;
        isApproved[msg.sender][msg.sender] = true;
        patientCount++;
    }
    
    /** 
    @dev Allows patient to edit their existing record
    */
    function editDetails(
        uint _id, 
        string memory _govMedicalDID, 
        uint _phone, 
        string memory _gender, 
        uint _dob, 
        uint _height, 
        uint _weight,  
        string  memory _bloodGroup, 
        string  memory _allergies, 
        string  memory _medication
        ) public {
        require(isPatient[msg.sender]);
        Patients storage p = patients[msg.sender];
        
        p.id = _id;
        p.govMedicalDID = _govMedicalDID;
        p.phone = _phone;
        p.gender = _gender;
        p.dob = _dob;
        p.height = _height; 
        p.weight = _weight;
        p.bloodGroup = _bloodGroup;
        p.allergies = _allergies;
        p.medication = _medication;
        p.addr = msg.sender;    
    }

    function setDoctor(
        uint _id, 
        string memory _name, 
        uint _phone, 
        string  memory _gender, 
        uint _dob, 
        string  memory _qualifications
        ) public {
        require(!isDoctor[msg.sender]);
        Doctors storage d = doctors[msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualifications = _qualifications;
        d.addr = msg.sender;
        d.date = block.timestamp;
        
        doctorList.push(msg.sender);
        isDoctor[msg.sender] = true;
        doctorCount++;
    }

    /** 
    @dev Allows doctors to edit their existing profile
    */
    function editDoctor(
        uint _id, 
        string memory _name, 
        uint _phone, 
        string  memory _gender, 
        uint _dob, 
        string  memory _qualifications
        ) public {
        require(isDoctor[msg.sender]);
        Doctors storage d = doctors[msg.sender];
        
        d.id = _id;
        d.name = _name;
        d.phone = _phone;
        d.gender = _gender;
        d.dob = _dob;
        d.qualifications = _qualifications;
        d.addr = msg.sender;
    }

    function setAppointment(
        address _addr, 
        uint _date, 
        uint _time, 
        string memory _diagnosis, 
        string memory _prescription, 
        string memory _description, 
        string memory _status
        ) public {
        require(isDoctor[msg.sender]);
        Appointments storage a = appointments[_addr];
        
        a.doctorAddr = msg.sender;
        a.patientAddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;
        a.creationDate = block.timestamp;

        appointmentList.push(_addr);
        appointmentCount++;
        AppointmentPerPatient[_addr]++;
    }
    
    function updateAppointment(
        address _addr, 
        uint _date, 
        uint _time, 
        string memory _diagnosis, 
        string memory _prescription, 
        string memory _description, 
        string memory _status
        ) public {
        require(isDoctor[msg.sender]);
        Appointments storage a = appointments[_addr];
        
        a.doctorAddr = msg.sender;
        a.patientAddr = _addr;
        a.date = _date;
        a.time = _time;
        a.diagnosis = _diagnosis;
        a.prescription = _prescription; 
        a.description = _description;
        a.status = _status;
    }
    
    /**
    @dev Owner of the record must give permission to the doctor they wish to allow view their records
     */
    function givePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = true;
        permissionGrantedCount++;
        return true;
    }

    /**
    @dev Owner of the record can revoke the permission granted to doctors to view records
     */
    function RevokePermission(address _address) public returns(bool success) {
        isApproved[msg.sender][_address] = false;
        return true;
    }

    /**
    @dev Retrieve a list of all patients addresses
     */
    function getPatients() public view returns(address[] memory) {
        return patientList;
    }

    /**
    @dev Retrieve a list of all doctors addresses
     */
    function getDoctors() public view returns(address[] memory) {
        return doctorList;
    }

    /**
    @dev Retrieve a list of all appointments addresses
     */
    function getAppointments() public view returns(address[] memory) {
        return appointmentList;
    }
    
    /**
    @dev Search patient details by entering a patient's address.
    (Only the record owner or a doctor with permission will be allowed to access)
     */
    function searchPatient(address _address) public view returns(
        uint, 
        string memory, 
        uint, 
        string memory, 
        uint, 
        uint, 
        uint
        ) {
        require(isApproved[_address][msg.sender]);
        
        Patients storage p = patients[_address];
        
        return (p.id, p.govMedicalDID, p.phone, p.gender, p.dob, p.height, p.weight);
    }

    /**
    @dev Search patient's medical history by entering a patient's address.
    (Only the record owner or a doctor with permission will be allowed to access)
    */
    function searchPatientMedicalHistory(address _address) public view returns( 
        string memory, 
        string memory, 
        string memory
        ) {
        require(isApproved[_address][msg.sender]);
        
        Patients storage p = patients[_address];
        
        return (p.bloodGroup, p.allergies, p.medication);
    }

    /**
    @dev Search doctor details by entering a doctor's address. 
    (Only the doctor will be allowed to access)
    */
    function searchDoctor(address _address) public view returns(
        uint, 
        string memory, 
        uint, 
        string memory, 
        uint, 
        string memory
        ) {
        require(isDoctor[_address]);
        
        Doctors storage d = doctors[_address];
        
        return (d.id, d.name, d.phone, d.gender, d.dob, d.qualifications);
    }
    
    /**
    @dev Search appointment details by entering a patient's address
    */
    function searchAppointment(address _address) public view returns(
        address, 
        string memory, 
        uint, 
        uint, 
        string memory, 
        string memory, 
        string memory, 
        string memory
        ) {
        Appointments storage a = appointments[_address];
        Doctors storage d = doctors[a.doctorAddr];

        return (a.doctorAddr, d.name, a.date, a.time, a.diagnosis, a.prescription, a.description, a.status);
    }

    /**
    @dev Search patient record creation date by entering a patient's address
    */
    function searchRecordDate(address _address) public view returns(uint) {
        Patients storage p = patients[_address];
        
        return (p.date);
    }

    /**
    @dev Search doctor profile creation date by entering a doctor's address
    */
    function searchDoctorDate(address _address) public view returns(uint) {
        Doctors storage d = doctors[_address];
        
        return (d.date);
    }

    /**
    @dev Search appointment creation date by entering a patient's address
    */
    function searchAppointmentDate(address _address) public view returns(uint) {
        Appointments storage a = appointments[_address];
        
        return (a.creationDate);
    }

    function getPatientCount() public view returns(uint) {
        return patientCount;
    }

    function getDoctorCount() public view returns(uint) {
        return doctorCount;
    }

    function getAppointmentCount() public view returns(uint) {
        return appointmentCount;
    }

    function getPermissionGrantedCount() public view returns(uint) {
        return permissionGrantedCount;
    }

    function getAppointmentPerPatient(address _address) public view returns(uint) {
        return AppointmentPerPatient[_address];
    }
}
// Mac OS build : clang++ -std=c++11 -stdlib=libc++ -Weverything main.cpp

#include <stdio.h>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <vector>
#include <iomanip>


// enum class DetectionState: uint8_t {
//     NONE_STATE = 0x00,
//     WAIT_FOR_DETECTION_START = 0x01,
//     WAIT_FOR_DETECTION_ALARM = 0x02,
//     DETECTION_COMPLETE = 0x03,
//     SENT_DETECTION_STOP = 0x04
// };

// enum class TrainState: uint8_t {
//     NONE_STATE = 0x00,
//     WAIT_FOR_TRAIN_START = 0x01,
//     WAIT_FOR_TRAIN_PROGRESS = 0x02,
//     TRAIN_COMPLETE = 0x03,
//     SENT_TRAIN_STOP = 0x04
// };
enum class ParamSetupStates {
    NONE,
    START,
    START_OK,
    DATA,
    DATA_OK,
    END
};

enum class DetectionStates {
    NONE,
    START,
    START_OK,
    DATA,
    END
};

enum class TrainStates {
    NONE,
    START,
    START_OK,
    DATA,
    END
};

enum class EngineMode: uint8_t {
    NONE_MODE = 0x00,
    TRAIN_MODE = 0x01,
    DETECTION_MODE = 0x02
};

enum class Func : uint8_t {
    SETUP = 0x01,
    CONTROL = 0x02,
    ALARM = 0x03,
    FUNC_4 = 0x04,
    RECEIVE = 0x05
};

enum class Mode : uint8_t {
    NONE = 0x00,
    TRAIN = 0x01,
    DETECTION = 0x02
};

enum class CmdResponse : uint8_t {
    NONE = 0x00,
    START = 0x01,
    STOP = 0x02,
    SUCCESS = 0x03,
    FAIL = 0x04
};

enum class AddMsgFlag : uint8_t {
    NONE = 0x00,
    EXIST = 0x01
};

enum class Vocabulary {
    ALARM_TRAIN_START,
    ALARM_TRAIN_SUCCESS,
    ALARM_TRAIN,
    ALARM_DETECTION_START,
    ALARM_DETECTION_STOP,
    ALARM_DETECTION,
    PARAMETER_SETUP,
    PARAMETER_SETUP_OK,
    PARAMETER_STRUCTURE,
    PARAMETER_STRUCTURE_OK,
    CONTROL_DETECTION_START,
    CONTROL_DETECTION_STOP,
    CONTROL_TRAIN_START,
    CONTROL_TRAIN_STOP
};

enum class EngineMsgID {
    DETECTION_PARAMETER_SETUP_START, // QGC -> Engine
    DETECTION_PARAMETER_DATA_OK, // Engine -> QGC
    DETECTION_PARAMETER_SETUP_START_OK = DETECTION_PARAMETER_DATA_OK, // Engine -> QGC
    DETECTION_PARAMETER_DATA, // QGC -> Engine
    DETECTION_CONTROL_START, // QGC -> Engine
    DETECTION_ALARM_START, // Engine -> QGC
    DETECTION_ALARM_DATA, // Engine -> QGC
    DETECTION_CONTROL_STOP, // QGC -> Engine
    TRAIN_PARAMETER_SETUP_START, // QGC -> Engine
    TRAIN_PARAMETER_DATA_OK, // Engine -> QGC
    TRAIN_PARAMETER_SETUP_START_OK = TRAIN_PARAMETER_DATA_OK, // Engine -> QGC
    TRAIN_PARAMETER_DATA, // QGC -> Engine
    TRAIN_CONTROL_START, // QGC -> Engine
    TRAIN_ALARM_START, // Engine -> QGC
    TRAIN_ALARM_PROGRESS, // Engine -> QGC
    TRAIN_ALARM_DONE, // Engine -> QGC
    TRAIN_CONTROL_STOP, // QGC -> Engine
    UNKNOWN // Default value
};


class EngineMsg {
private:
    static const uint8_t START1 = 0x47;
    static const uint8_t START2 = 0x71;

    uint8_t func;
    uint8_t mode;
    uint8_t cmd_response;
    uint8_t add_msg_flag;
    uint16_t add_msg_len;
    uint8_t* add_msg;
    uint16_t length;

public:
    EngineMsg() {
        func = 0;
        mode = 0;
        cmd_response = 0;
        add_msg_flag = 0;
        add_msg_len = 0;
        add_msg = nullptr;
        length = 0;
    }

    ~EngineMsg() {
        if (add_msg != nullptr) {
            delete[] add_msg;
        }
    }

    void setMsgFields(Func func, Mode mode, CmdResponse cmd_response, AddMsgFlag add_msg_flag, uint16_t add_msg_len, uint8_t* add_msg) {
        this->func = static_cast<uint8_t>(func);
        this->mode = static_cast<uint8_t>(mode);
        this->cmd_response = static_cast<uint8_t>(cmd_response);
        this->add_msg_flag = static_cast<uint8_t>(add_msg_flag);
        this->add_msg_len = add_msg_len;

        if (this->add_msg != nullptr) {
            delete[] this->add_msg;
            this->add_msg = nullptr;
        }

        if (add_msg != nullptr && add_msg_len > 0) {
            if (add_msg_len == 1) {
                this->add_msg = new uint8_t(add_msg[0]);
                this->add_msg[0] = add_msg[0];
            }
            else {
                this->add_msg = new uint8_t[add_msg_len];
                std::memcpy(this->add_msg, add_msg, add_msg_len);
            }
        }
    }

    std::vector<uint8_t> toBytes() {
        std::vector<uint8_t> byte_vector;

        if (add_msg_flag == 0) {
            length = 3; // func, mode, cmd_response
            uint8_t* buffer = new uint8_t[length + 4];

            buffer[0] = START1;
            buffer[1] = START2;
            // std::memcpy(buffer + 2, &length, sizeof(uint16_t));
            buffer[2] = static_cast<uint8_t>(length >> 8);
            buffer[3] = static_cast<uint8_t>(length);
            
            buffer[4] = func;
            buffer[5] = mode;
            buffer[6] = cmd_response;
            byte_vector.assign(buffer, buffer + length + 4);
            // return buffer;
        }
        else {
            length = 3 + 1 + 2 + add_msg_len; // func, mode, cmd_response, add_msg_flag, add_msg_len, add_msg
            uint8_t* buffer = new uint8_t[length + 4];
            buffer[0] = START1;
            buffer[1] = START2;
            // std::memcpy(buffer + 2, &length, sizeof(uint16_t));
            buffer[2] = static_cast<uint8_t>(length >> 8);
            buffer[3] = static_cast<uint8_t>(length);
            
            buffer[4] = func;
            buffer[5] = mode;
            buffer[6] = cmd_response;
            buffer[7] = add_msg_flag;
            // std::memcpy(buffer + 8, &add_msg_len, sizeof(uint16_t));
            buffer[8] = static_cast<uint8_t>(add_msg_len >> 8);
            buffer[9] = static_cast<uint8_t>(add_msg_len);
            
            std::memcpy(buffer + 10, add_msg, add_msg_len);
            byte_vector.assign(buffer, buffer + length + 4);
            
            // std::cout<< "length: " << length << "   add_msg_len: "<<add_msg_len << std::endl;
            // return buffer;
        }
        return byte_vector;
    }

    bool fromBytes(const uint8_t* data, uint16_t data_len) {
        add_msg_flag = static_cast<uint8_t>(AddMsgFlag::NONE);
        add_msg_len = 0;
    
        if (data_len < 8) {
            uint8_t start1 = data[0];
            uint8_t start2 = data[1];
            length = (data[2] << 8) | data[3];
            // std::memcpy(&length, data + 2, sizeof(uint16_t));
            func = data[4];
            mode = data[5];
            cmd_response = data[6];

            if (start1 != START1 || start2 != START2 || length != 3) {
                std::cout << "It is not valid short data!" << std::endl;
                return false;
            }else {
                std::cout << "It is Good short data!" << std::endl;
            }
        }
        else {
            uint8_t start1 = data[0];
            uint8_t start2 = data[1];
            length = (data[2] << 8) | data[3]; //std::memcpy(&length, data + 2, sizeof(uint16_t));
            func = data[4];
            mode = data[5];
            cmd_response = data[6];
            add_msg_flag = data[7];
            add_msg_len = (data[8] << 8) | data[9];//std::memcpy(&add_msg_len, data + 8, sizeof(uint16_t));
            // add_msg_len = (data[8] << 8) | data[9];

            if (start1 != START1 || start2 != START2 || length != data_len - 4) {
                std::cout << "It is not valid long data!" << std::endl;
                std::cout << "start1 : "<< start1 << " start2 : " << start2 << " " << length << " " << data_len << std::endl;
                return false;
            }else {
                std::cout << "It is Good long data!" << std::endl;
            }

            if (add_msg_len > 0) {
                add_msg = new uint8_t[add_msg_len];
                std::memcpy(add_msg, data + 10, add_msg_len);
            }
        }

        return true;
    }

    bool compareBytes(const uint8_t* data, uint16_t data_len) {
        std::vector<uint8_t> my = toBytes(); // uint8_t* buffer = toBytes();
        bool result = (my == std::vector<uint8_t>(data, data + data_len));
        return result;
    }

    bool compare(EngineMsg& other) {
        auto buffer1 = toBytes();
        auto buffer2 = other.toBytes();
        bool result = buffer1 == buffer2;  // bool result = (std::memcmp(buffer1, buffer2, sizeof(buffer1)) == 0);
        return result;
    }

    bool compareVector(std::vector<uint8_t> target) {
        auto buffer = toBytes();
        bool result = buffer == target;
        return result;
    }

    void addAddMsgFromJson(const char* json_data) {
        add_msg_len = std::strlen(json_data);
        add_msg = new uint8_t[add_msg_len];
        std::memcpy(add_msg, json_data, add_msg_len);
    }

    void useVocabulary(EngineMsgID messageId, uint8_t* msg = nullptr, uint16_t msg_len = 0) {
                switch (messageId) {
            case EngineMsgID::DETECTION_PARAMETER_SETUP_START:
                setMsgFields(Func::SETUP, Mode::DETECTION, CmdResponse::NONE, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::DETECTION_PARAMETER_SETUP_START_OK:
                setMsgFields(Func::SETUP, Mode::DETECTION, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::DETECTION_PARAMETER_DATA:
                setMsgFields(Func::SETUP, Mode::DETECTION, CmdResponse::NONE, AddMsgFlag::EXIST, msg_len, msg);
                break;
            // case EngineMsgID::DETECTION_PARAMETER_DATA_OK:
            //     setMsgFields(Func::SETUP, Mode::DETECTION, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
            //     break;
            case EngineMsgID::DETECTION_CONTROL_START:
                setMsgFields(Func::CONTROL, Mode::DETECTION, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::DETECTION_ALARM_START:
                setMsgFields(Func::ALARM, Mode::DETECTION, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::DETECTION_ALARM_DATA:
                setMsgFields(Func::ALARM, Mode::DETECTION, CmdResponse::NONE, AddMsgFlag::EXIST, msg_len, msg);
                break;
            case EngineMsgID::DETECTION_CONTROL_STOP:
                setMsgFields(Func::CONTROL, Mode::DETECTION, CmdResponse::STOP, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_PARAMETER_SETUP_START:
                setMsgFields(Func::SETUP, Mode::TRAIN, CmdResponse::NONE, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_PARAMETER_SETUP_START_OK:
                setMsgFields(Func::SETUP, Mode::TRAIN, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_PARAMETER_DATA:
                setMsgFields(Func::SETUP, Mode::TRAIN, CmdResponse::NONE, AddMsgFlag::EXIST, msg_len, msg);
                break;
            // case EngineMsgID::TRAIN_PARAMETER_DATA_OK:
            //     setMsgFields(Func::SETUP, Mode::TRAIN, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
            //     break;
            case EngineMsgID::TRAIN_CONTROL_START:
                setMsgFields(Func::CONTROL, Mode::TRAIN, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_ALARM_START:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_ALARM_PROGRESS:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::NONE, AddMsgFlag::EXIST, 1, msg);
                break;
            case EngineMsgID::TRAIN_ALARM_DONE:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case EngineMsgID::TRAIN_CONTROL_STOP:
                setMsgFields(Func::CONTROL, Mode::TRAIN, CmdResponse::STOP, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            default:
                std::cout << "Invalid Vocabulary Message ID" << std::endl;
                break;
        }
    }
    
    void useVocabulary(Vocabulary vocabulary, uint8_t* msg = nullptr, uint16_t msg_len = 0) {
        switch (vocabulary) {
            case Vocabulary::ALARM_TRAIN_START:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::ALARM_TRAIN_SUCCESS:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::ALARM_TRAIN:
                setMsgFields(Func::ALARM, Mode::TRAIN, CmdResponse::NONE, AddMsgFlag::EXIST, sizeof(msg), msg);
                break;
            case Vocabulary::ALARM_DETECTION_START:
                setMsgFields(Func::ALARM, Mode::DETECTION, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::ALARM_DETECTION_STOP:
                setMsgFields(Func::ALARM, Mode::DETECTION, CmdResponse::STOP, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::ALARM_DETECTION:
                setMsgFields(Func::ALARM, Mode::DETECTION, CmdResponse::NONE, AddMsgFlag::EXIST, sizeof(msg), msg);
                break;
            case Vocabulary::PARAMETER_SETUP:
                setMsgFields(Func::SETUP, Mode::NONE, CmdResponse::NONE, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::PARAMETER_SETUP_OK:
                setMsgFields(Func::SETUP, Mode::NONE, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::PARAMETER_STRUCTURE:
                setMsgFields(Func::SETUP, Mode::NONE, CmdResponse::NONE, AddMsgFlag::EXIST, msg_len, msg);
                break;
            case Vocabulary::PARAMETER_STRUCTURE_OK:
                setMsgFields(Func::SETUP, Mode::NONE, CmdResponse::SUCCESS, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::CONTROL_DETECTION_START:
                setMsgFields(Func::CONTROL, Mode::DETECTION, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::CONTROL_DETECTION_STOP:
                setMsgFields(Func::CONTROL, Mode::DETECTION, CmdResponse::STOP, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::CONTROL_TRAIN_START:
                setMsgFields(Func::CONTROL, Mode::TRAIN, CmdResponse::START, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            case Vocabulary::CONTROL_TRAIN_STOP:
                setMsgFields(Func::CONTROL, Mode::TRAIN, CmdResponse::STOP, AddMsgFlag::NONE, 0x00, nullptr);
                break;
            default:
                throw std::invalid_argument("Invalid Vocabulary");
        }
    }
    EngineMsgID getMessageID(){
        switch(mode){
            case static_cast<uint8_t>(Mode::DETECTION):
                switch(func) {
                    case static_cast<uint8_t>(Func::SETUP):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::NONE)){
                            return EngineMsgID::DETECTION_PARAMETER_SETUP_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::SUCCESS)){
                            return EngineMsgID::DETECTION_PARAMETER_SETUP_START_OK;
                        }
                        break;
                    case static_cast<uint8_t>(Func::CONTROL):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::START)){
                            return EngineMsgID::DETECTION_CONTROL_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::STOP)){
                            return EngineMsgID::DETECTION_CONTROL_STOP;
                        }
                        break;
                    case static_cast<uint8_t>(Func::ALARM):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::START)){
                            return EngineMsgID::DETECTION_ALARM_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::NONE)){
                            return EngineMsgID::DETECTION_ALARM_DATA;
                        }
                        break;
                    default:
                        return EngineMsgID::UNKNOWN;
                }
                break;
            case static_cast<uint8_t>(Mode::TRAIN): 
                switch(func) {
                    case static_cast<uint8_t>(Func::SETUP):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::NONE)){
                            return EngineMsgID::TRAIN_PARAMETER_SETUP_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::SUCCESS)){
                            return EngineMsgID::TRAIN_PARAMETER_SETUP_START_OK;
                        }
                        break;
                    case static_cast<uint8_t>(Func::CONTROL):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::START)){
                            return EngineMsgID::TRAIN_CONTROL_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::STOP)){
                            return EngineMsgID::TRAIN_CONTROL_STOP;
                        }
                        break;
                    case static_cast<uint8_t>(Func::ALARM):
                        if(cmd_response == static_cast<uint8_t>(CmdResponse::START)){
                            return EngineMsgID::TRAIN_ALARM_START;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::NONE)){
                            return EngineMsgID::TRAIN_ALARM_PROGRESS;
                        }else if(cmd_response == static_cast<uint8_t>(CmdResponse::SUCCESS)){
                            return EngineMsgID::TRAIN_ALARM_DONE;
                        }
                        break;
                    default:
                        return EngineMsgID::UNKNOWN;
                }
                break;
            default:
                return EngineMsgID::UNKNOWN;
        }
        return EngineMsgID::UNKNOWN;
    }

    std::vector<uint8_t> getAddMsg() {
        return std::vector<uint8_t>(add_msg, add_msg + add_msg_len);
    }

    uint16_t getAddMsgLen() {
        return add_msg_len;
    }

};
class MessageHandler{
    private:
        EngineMsg* received_msg;
        ParamSetupStates param_setup_state;
        DetectionStates detection_state;
        TrainStates train_state;
        EngineMsg send_msg;
    public:
        MessageHandler() : received_msg(nullptr), param_setup_state(ParamSetupStates::NONE), detection_state(DetectionStates::NONE), train_state(TrainStates::NONE) {
        }

        void setReceivedMsg(EngineMsg& msg){
            received_msg = &msg;
        }
        void print_vector(std::vector<uint8_t> vec){
            for (uint8_t byte : vec){
                std::cout << std::hex << std::setw(2) << std::setfill('0') << static_cast<int>(byte) << " ";
           }
        }

        void handleQGCMessage() {
            if( received_msg == nullptr){
                std::cout << "No Message Received" << std::endl;
                return;
            }
            switch(received_msg->getMessageID()){
                case EngineMsgID::TRAIN_PARAMETER_SETUP_START:
                    send_msg.useVocabulary(EngineMsgID::TRAIN_PARAMETER_SETUP_START_OK);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    
                    param_setup_state = ParamSetupStates::START_OK;
                    break;
                case EngineMsgID::TRAIN_PARAMETER_SETUP_START_OK:
                    break;
                case EngineMsgID::TRAIN_PARAMETER_DATA:
                    send_msg.useVocabulary(EngineMsgID::TRAIN_PARAMETER_DATA_OK);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    param_setup_state = ParamSetupStates::END;
                    break;
                // case EngineMsgID::TRAIN_PARAMETER_DATA_OK:
                //     break;
                case EngineMsgID::TRAIN_CONTROL_START:
                    send_msg.useVocabulary(EngineMsgID::TRAIN_ALARM_START);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    train_state = TrainStates::DATA;
                    break;
                case EngineMsgID::TRAIN_CONTROL_STOP:
                    std::cout << "Train Control Stop Received" << std::endl;
                    train_state = TrainStates::END;
                    break;
                case EngineMsgID::TRAIN_ALARM_START:
                    break;
                case EngineMsgID::TRAIN_ALARM_PROGRESS:
                    break;
                case EngineMsgID::TRAIN_ALARM_DONE:
                    break;
                case EngineMsgID::DETECTION_PARAMETER_SETUP_START:
                    send_msg.useVocabulary(EngineMsgID::DETECTION_PARAMETER_SETUP_START_OK);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    detection_state = DetectionStates::START_OK;
                    break;
                case EngineMsgID::DETECTION_PARAMETER_SETUP_START_OK:
                    break;
                case EngineMsgID::DETECTION_PARAMETER_DATA:
                    send_msg.useVocabulary(EngineMsgID::DETECTION_PARAMETER_DATA_OK);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    param_setup_state = ParamSetupStates::END;
                    break;  
                case EngineMsgID::DETECTION_CONTROL_START:
                    send_msg.useVocabulary(EngineMsgID::DETECTION_ALARM_START);
                    std::cout << "send message";
                    print_vector(send_msg.toBytes());
                    detection_state = DetectionStates::DATA;
                    break;  
                case EngineMsgID::DETECTION_CONTROL_STOP:
                    std::cout << "Detection Control Stop Received" << std::endl;
                    detection_state = DetectionStates::END;
                    break;
                case EngineMsgID::DETECTION_ALARM_START:
                    break;
                case EngineMsgID::DETECTION_ALARM_DATA:
                    break;
                default:   
                    std::cout << "Invalid Train Message ID" << std::endl;
                    break;
            }
        }

        void handleEngineMessage() {
            switch(received_msg->getMessageID()){
                case EngineMsgID::TRAIN_PARAMETER_SETUP_START:
                    break;
                case EngineMsgID::TRAIN_PARAMETER_SETUP_START_OK:
                    std::cout << "TRAIN_PARAMETER_SETUP_START_OK : Train Parameter Setup Start OK" << std::endl;
                    param_setup_state = ParamSetupStates::START_OK;
                    break;
                case EngineMsgID::TRAIN_PARAMETER_DATA:
                    break;
                // case EngineMsgID::TRAIN_PARAMETER_DATA_OK:
                //     std::cout << "TRAIN_PARAMETER_DATA_OK : Train Parameter Data OK" << std::endl;
                //     param_setup_state = ParamSetupStates::END;
                //     break;
                case EngineMsgID::TRAIN_CONTROL_START:
                    break;
                case EngineMsgID::TRAIN_CONTROL_STOP:
                    break;
                case EngineMsgID::TRAIN_ALARM_START:
                    std::cout << "TRAIN_ALARM_START : Train Alarm Start" << std::endl;
                    train_state = TrainStates::DATA;
                    break;
                case EngineMsgID::TRAIN_ALARM_PROGRESS:
                    std::cout << "TRAIN_ALARM_PROGRESS : Progress : ";
                    print_vector(received_msg->getAddMsg());
                    train_state = TrainStates::DATA;
                    break;
                case EngineMsgID::TRAIN_ALARM_DONE:
                    std::cout << "TRAIN_ALARM_DONE : Train Alarm Done" << std::endl;
                    train_state = TrainStates::END;
                    break;
                case EngineMsgID::DETECTION_PARAMETER_SETUP_START:
                    break;
                case EngineMsgID::DETECTION_PARAMETER_SETUP_START_OK:
                    std::cout << "DETECTION_PARAMETER_SETUP_START_OK : " << std::endl;
                    detection_state = DetectionStates::START_OK;
                    break;
                case EngineMsgID::DETECTION_PARAMETER_DATA:
                    break;
                case EngineMsgID::DETECTION_CONTROL_START:
                    break;
                case EngineMsgID::DETECTION_CONTROL_STOP:
                    break;
                case EngineMsgID::DETECTION_ALARM_START:
                    std::cout << "DETECTION_ALARM_START : " << std::endl;
                    detection_state = DetectionStates::DATA;
                    break;
                case EngineMsgID::DETECTION_ALARM_DATA:
                    std::cout << "DETECTION_ALARM_DATA : data : ";
                    print_vector(received_msg->getAddMsg());
                    detection_state = DetectionStates::DATA;
                    break;
                default:   
                    std::cout << "Invalid Train Message ID" << std::endl;
                    break;
            }
        }

};

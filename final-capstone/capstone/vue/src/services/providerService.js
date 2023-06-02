import axios from 'axios';

export default {

    getAllProviders(){
        return axios.get('/providers');
    },

    getDoctorUserIdByUsername(username){
        return axios.get(`/${username}`);
    },

    getDoctorByUserId(id){
        return axios.get(`/pid/${id}`);
        
    },
    updateDoctorInformation(doctor){
        return axios.put(`/pid/update/${doctor.doctorId}`,doctor);
    }

}
    



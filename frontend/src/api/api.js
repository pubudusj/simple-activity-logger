import axios from 'axios'

export default {
    saveActivity(payload) {
        return new Promise((resolve) => {
            axios.post(process.env.VUE_APP_API_BASE_URL + 'activity', payload).then(response => {
                    resolve(response.data);
                })
                .catch((error) => {
                    console.log(error.statusText);
                });
        })
    },
    getActivitesByDate(date) {
        return new Promise((resolve) => {
            axios.get(process.env.VUE_APP_API_BASE_URL + 'activity/' + date, {
                crossDomain : true,
                headers: { 'Content-Type': 'application/json' }
            }).then(response => {
                    resolve(response.data.data);
                })
                .catch((error) => {
                    console.log(error.statusText);
                });
        })
    },
    delete(payload) {
        return new Promise((resolve) => {
            axios.delete(process.env.VUE_APP_API_BASE_URL + 'activity', { data: payload}).then(response => {
                    resolve(response.data.data);
                })
                .catch((error) => {
                    console.log(error.statusText);
                });
        })
    },
}
<template>
  <v-container>
    <v-form ref="form" v-model="valid">
      <v-row class="text-center">
        <v-col class="mb-4" cols="12">
          <v-row justify="center">
            <h2 class="display-1 font-weight mb-2">
            Activity Logger
          </h2>
          </v-row>
          <v-row justify="center">
            <v-radio-group v-model="activityType" mandatory :rules="[v => !!v || 'Select a activity type']">
              <v-radio
                class="activity-type"
                label="Door Slam"
                value="doorslam"
              ></v-radio>
              <v-radio
                class="activity-type"
                label="Punch"
                value="punch"
              ></v-radio>
              <v-radio
                class="activity-type"
                label="Footsteps"
                value="footsteps"
              ></v-radio>
            </v-radio-group>
          </v-row>
          <v-row justify="center">
            <div class="datePickerInput">
              <v-menu
                ref="menu1"
                v-model="menu1"
                :close-on-content-click="false"
                transition="scale-transition"
                offset-y
                max-width="290px"
                min-width="290px"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    class="datePickerInput"
                    v-model="activityDate"
                    label="Date"
                    prepend-icon="mdi-calendar"
                    v-bind="attrs"
                    v-on="on"
                    :rules="[v => !!v || 'Select a date']"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="activityDate"
                  no-title
                  @input="menu1 = false"
                ></v-date-picker>
              </v-menu>
            </div>
          </v-row>
          <v-row justify="center">
            <div class="hourSelect">
              <v-select v-model="hour"
              :items="hours"
              item-text="value"
              item-value="id"
              label="Hour" ></v-select>
            </div>
            <div class="minutesSelect">
              <v-select
                v-model="minute"
                :items="minutes"
                item-text="value"
                item-value="id"
                label="Minute"
                :rules="[v => !!v || 'Select minute']"
              ></v-select>
            </div>
          </v-row>
          <v-row justify="center">
            <div class="commentField">
              <v-text-field v-model="comment" label="Comment"></v-text-field>
            </div>
          </v-row>
          <v-row justify="center">
            <div class="submitButton">
              <v-btn
              color="primary"
              class="mr-4"
              @click="save"
            >
              Save
            </v-btn>
            </div>
          </v-row>

          <h2 style="margin-top: 20px">Today Events</h2>
          <v-row justify="center">
            <v-simple-table>
              <template v-slot:default>
                <tbody>
                  <tr
                    v-for="activity in todayActivities"
                    :key="activity.id"
                  >
                    <td>{{ activity.activity_type }}</td>
                    <td>{{ activity.timestamp | formatTimestamp }}</td>
                    <td><v-btn color="error" x-small @click="deleteActivity(activity)">Delete</v-btn></td>
                  </tr>
                </tbody>
              </template>
            </v-simple-table>
          </v-row>
        </v-col>
      </v-row>
    </v-form>
  </v-container>
</template>

<script>
import api from '../api/api'

export default {
  name: "Activity",

  data: () => ({
    activityType: null,
    valid: false,
    menu1: false,
    minute: '00',
    hour: '00',
    comment: "",
    todayActivities: [],
    todayDate: null,
    debug: null,
  }),
  computed: {
    minutes() {
      var minutes = [];
      var i;
      for (i = 0; i < 60; i++) {
        var l = i;
        if (i < 10) {
          l = '0' + i;
        }
        minutes.push({id: l, value: l});
      }
      return minutes;
    },
    hours() {
      var hours = [];
      var i;
      for (i = 0; i < 24; i++) {
        var l = i;
        if (i < 10) {
          l = '0' + i;
        }
        hours.push({id: l, value: l});
      }
      return hours;
    },
  },
  filters: {
    formatTimestamp: function(timestamp) {      
        var dateVal = new Date(timestamp * 1000);

        return dateVal.getFullYear() + '-' +
          (dateVal.getMonth()+1 < 10 ? '0' + (dateVal.getMonth()+1) : dateVal.getMonth()+1) + '-' +
          (dateVal.getDate() < 10 ? ('0' + dateVal.getDate()) : dateVal.getDate()) + ' ' +
          (dateVal.getHours() < 10 ? ('0' + dateVal.getHours()) : dateVal.getHours()) + ':' +
          (dateVal.getMinutes() < 10 ? ('0' + dateVal.getMinutes()) : dateVal.getMinutes());
    }
  },
  created() {
    var today = new Date();
    this.minute = today.getMinutes() < 10 ? ('0' + today.getMinutes()) : today.getMinutes();
    this.hour = today.getHours();
    this.activityDate = today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate();
    this.todayDate = today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate();
    this.fetchTodayActivities(this.todayDate);
  },
  methods: {
    save () {
        
        if (this.$refs.form.validate()) {
          var time = this.activityDate + 'T' + this.hour + ':' + this.minute + ':00';
          var timestamp = new Date(time).getTime()/1000;
          var payload = {
            time: time,
            activityDate: this.activityDate,
            hour: this.hour,
            minute: this.minute,
            timestamp: timestamp,
            date: this.activityDate,
            activity_type: this.activityType,
            comments: this.comment,
          }
          this.debug = payload;
          var self = this
          api.saveActivity(payload).then(function(){
            self.fetchTodayActivities(self.todayDate)
          });
        }
      },
    fetchTodayActivities(date) {
      var self = this
      api.getActivitesByDate(date).then(function(data) {
        self.todayActivities = data
      });
    },
    deleteActivity(activity) {
      var self = this
      api.delete({
        'activity_id': activity.activity_id,
        'timestamp': activity.timestamp
      }).then(function() {
        self.todayActivities = self.todayActivities.filter(act => act.activity_id != activity.activity_id);
      });
    }
  },
};
</script>

<style scoped>
.activity-type >>> i,
.activity-type >>> label {
  padding-bottom: 20px;
  font-size: 30px !important;
}

.datePickerInput {
  width: 200px;
  font-size: 20px;
}

.minutesSelect,
.hourSelect {
  width: 150px;
}

.commentField {
  width: 300px;
}

.table >>> td{
  text-align: left !important;
}
</style>

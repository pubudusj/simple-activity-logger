<template>
  <v-app>
    <v-main>
      <Activity/>
    </v-main>
  </v-app>
</template>

<script>
import Activity from './components/Activity';

export default {
  name: 'App',
  metaInfo: {
    title: 'Activity Logger'
  },

  components: {
    Activity,
  },

  data: () => ({
    //
  }),
};
</script>

<style scoped>
@media screen and (display-mode: standalone) {
  header {
    height: 88px !important;
  }
}
header {
  padding-top: env(safe-area-inset-top);
}
</style>
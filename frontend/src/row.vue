<template>
  <v-layout row>
    <v-flex>
      <slot name='col1' />
    </v-flex>
    <v-flex>
      <slot name='col2' />
    </v-flex>
    <v-flex v-if="$vuetify.breakpoint.name != 'xs'">
      <slot name='col3' />
    </v-flex>
    <v-flex>
      <slot name='col4' />
    </v-flex>
  </v-layout>
</template>

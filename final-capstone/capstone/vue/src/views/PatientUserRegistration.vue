<template>
  <div id="register" class="text-center">
    <form class="form" @submit.prevent="register">
      <h2 class="h2">Create Patient Account</h2>
      <div role="alert" v-if="registrationErrors">
        {{ registrationErrorMsg }}
      </div>
      <div class="form-input-group">
        <label for="username">Username</label>
        <input
          type="text"
          id="username"
          v-model="user.username"
          required
          autofocus
        />
      </div>
      <div class="form-input-group">
        <label for="password">Password</label>
        <input type="password" id="password" v-model="user.password" required />
      </div>
      <div class="form-input-group">
        <label for="confirmPassword">Confirm Password</label>
        <input
          type="password"
          id="confirmPassword"
          v-model="user.confirmPassword"
          required
        />
      </div>
      <button type="submit">Create Account</button>
      <p>
        <router-link :to="{ name: 'login' }"
          >Already have an account? Log in.</router-link
        >
      </p>
    </form>
  </div>
</template>

<script>
import authService from "../services/authService.js";

export default {
  name: "register",
  data() {
    return {
      user: {
        username: "",
        password: "",
        confirmPassword: "",
        role: "user",
      },
      loginUser: {
        username: "",
        password: "",
      },
      registrationErrors: false,
      registrationErrorMsg: "There were problems registering this user.",
    };
  },
  methods: {
    register() {
      if (this.user.password != this.user.confirmPassword) {
        this.registrationErrors = true;
        this.registrationErrorMsg = "Password & Confirm Password do not match.";
      } else {
        authService
          .register(this.user)
          .then((response) => {
            if (response.status == 201) {
              this.loginUser.username = this.user.username;
              this.loginUser.password = this.user.password;
              authService.login(this.loginUser).then((res) => {
                if (res.status == 200) {
                  this.$store.commit("SET_AUTH_TOKEN", res.data.token);
                  this.$store.commit("SET_USER", res.data.user);
                  authService.getRole(this.user.username).then(res=>{
                    const roles = res.data;
                    this.$store.commit("SET_ROLE", roles);
                     console.log("login" + this.$store.state.role.role);
                  });
                  this.$router.push({
                    path: "/patient-account-creation",
                    query: {
                      registration: "success",
                      username: this.user.username,
                    },
                  });
                }
              });
            }
          })
          .catch((error) => {
            const response = error.response;
            this.registrationErrors = true;
            if (response.status === 400) {
              this.registrationErrorMsg = "Bad Request: Validation Errors";
            }
          });
      }
    },
    clearErrors() {
      this.registrationErrors = false;
      this.registrationErrorMsg = "There were problems registering this user.";
    },
  },
};
</script>

<style scoped>
#register {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 65vh;
  font-family: Arial, sans-serif;
  background-color: #f2f2f2;
}

form {
  width: 400px;
  max-width: 100%;
  padding: 2rem;
  background-color: #ffffff;
  border-radius: 5px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  margin-bottom: 1rem;
}

.form-input-group {
  margin-bottom: 1rem;
}

label {
  margin-right: 0.5rem;
}

input[type="text"],
input[type="email"],
input[type="password"] {
  width: 100%;
  padding: 10px;
  margin-bottom: 20px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

button {
  background-color: #04abcc;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px;
  width: 100%;
  margin-bottom: 18px;
}

button:hover {
  background-color: #048eaa;
}

.h2 {
  display: inline-block;
  font-size: 23px;
  font-weight: bold;
  padding-bottom: 23px;
}
</style>
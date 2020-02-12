document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("user-div").style.display="none";
  userSignUpForm()
  userLoginForm()
})

let currentUser = null
let analyzedRepositories = document.getElementById("analyzed-repositories")
let unanalyzedRepositories = document.getElementById("unanalyzed-repositories")

function userLoginForm(){
  let login = document.getElementById("user-login")
  login.addEventListener("submit", (event) => {
    event.preventDefault()
    let user = {name: event.target.name.value}
    loginUser(user)
  })
}

function loginUser(user){
  fetch('http://localhost:3000/users')
  .then(res => res.json())
  .then(data => {
    usersCheck(data, user)
  })
  .catch(err => console.log(err))
}

function usersCheck(data, user){
  let h3 = document.getElementById("current-user")
  let userExists = data.find(u => {
    return u.name == user.name
  })
  if(userExists){
    currentUser = userExists
    // h3.innerText = currentUser.name
    // let editUser = document.createElement("button")
    // editUser.textContent = "Edit User"
    // h3.appendChild(editUser)
    displayUserName();
    document.getElementById("user-div").style.display="inline";
    renderRepos(currentUser)
  } else {
    alert("No Such User, Try Again!")
  }
}

function displayUserName (editedUser = currentUser) {
    document.getElementById("current-user").innerText = editedUser.name
}

function userSignUpForm(){
  let signUp = document.getElementById("user-sign-up")
  signUp.addEventListener("submit", (event) => {
    event.preventDefault()
    let user = {name: event.target.name.value}
    persistUser(user)
  })
}

function persistUser(user){
  fetch('http://localhost:3000/users/', {
    method: 'POST',
    headers: {"Content-Type": "application/json",
              Accept: "application/json"
            },
    body: JSON.stringify(user)         
  })
  .then(res => console.log(res))
  .catch(err => console.log(err))
}

function renderRepos(user) {
    user.repos.forEach(repo => {
        showRepo(repo)
    });
}


function showRepo(repo) {
    let repoDiv = document.createElement("div")
    repoDiv.className = "card"

    let p = document.createElement("p")
    p.textContent = repo.nickname

    let editButton = document.createElement("button")
    editButton.textContent = "Change Repository Nickname"
    editButton.addEventListener("click", () => {
        // p.style.display = 'none'
        let editInput = document.createElement("input")
        editInput.type = "text";
        editInput.id = "edit"
        editInput.name = "nickname";
        editInput.value = repo.nickname
        p.parentNode.insertBefore(editInput, p.nextSibling);
        p.parentNode.removeChild(p);

        let submitEdit = document.createElement("button")
        submitEdit.textContent = "Submit Name Change"
        editButton.parentNode.insertBefore(submitEdit, editButton.nextSibling);
        editButton.parentNode.removeChild(editButton)

        submitEdit.addEventListener("click", (event) => {
            event.preventDefault();
            const value = document.getElementById("edit").value
            // let repo = {nickname: event.target.value}
            // let repo = {nickname:}
            editRepoName(repo, value);
            repoDiv.remove();
        })
    })
    
    let u = document.createElement("p")
    u.textContent = repo.url

    let button = document.createElement("button")
    button.className = "analyze-button"

    let deleteButton = document.createElement("button")
    deleteButton.textContent = "Delete this Repository"
    deleteButton.addEventListener("click", () => {
        deleteRepo(repo, repoDiv);
    })
    
    repoDiv.appendChild(p)
    repoDiv.appendChild(editButton)
    repoDiv.appendChild(u)
    repoDiv.appendChild(button)
    repoDiv.appendChild(deleteButton)

    analyzeButtonTextAndFunc(repo, repoDiv)
}

function analyzeButtonTextAndFunc(repo, repoDiv){
  let button = repoDiv.getElementsByClassName("analyze-button")[0]
    if (repo.analyzed) {
      analyzedRepositories.prependChild(repoDiv)
      button.textContent = "See Analysis"
  } else {
      unanalyzedRepositories.prependChild(repoDiv)
      button.textContent = "Analyze Repo"
      button.addEventListener("click", ()=>{
        analyzeRepo(repo, repoDiv)
      })
  }
}

function analyzeRepo(repo, repoDiv){
  fetch(`http://localhost:3000/repos/${repo.id}/analysis`)
  .then(res => res.json())
  .then(data => {
    repo = data
    analyzeButtonTextAndFunc(repo, repoDiv)
  })
  .catch(err => console.log(err))
}

function newRepoForm(){

    let main = document.getElementById("main")

    let form = document.createElement("form")
    // div.className = "card"

    // div.innerHTML = "";

    let nickname = document.createElement("p")
    nickname.textContent = "Enter the nickname of your repository"

    let nicknameInput = document.createElement("input")
    nicknameInput.type = "text";
    nicknameInput.name = "nickname";
    
    let p = document.createElement("p")
    p.textContent = "Enter the Url of your repository"

    let input = document.createElement("input")
    input.type = "text";
    input.name = "url"

    let button = document.createElement("button")
    button.textContent = "Submit Repository"

    form.addEventListener("submit", (event) => {
        event.preventDefault();
        console.log(event.target.nickname.value)
        let repo = {nickname: event.target.nickname.value, url: event.target.url.value, analyzed: false, user_id: currentUser.id}
        // let repo = {nickname:}
        addRepository(repo)
        form.remove();
    })
    

    form.appendChild(nickname)
    form.appendChild(nicknameInput)
    form.appendChild(p)
    form.appendChild(input)
    form.appendChild(button)
    main.appendChild(form)
}

function addRepository(repo) {
    console.log(repo)
    fetch('http://localhost:3000/repos/', {
        method: 'POST',
        headers: {"Content-Type": "application/json",
                  Accept: "application/json"
                },
        body: JSON.stringify(repo)         
      }).then(res=> res.json())
      .then(res => {
          console.log(res)
          return res
      })
      .then(repo => {
        showRepo(repo)
      })
      .catch(err => console.log(err))
} 

function deleteRepo(repo, repoDiv) {
    fetch(`http://localhost:3000/repos/${repo.id}`, {
        method: "DELETE"
    })
    .then(res => {
        repoDiv.remove()
    })
} 

function deleteUser(currentUser) {
    fetch(`http://localhost:3000/users/${currentUser.id}`, {
        method: "DELETE"
    })
    // .then(res => {
    //     currentUser.remove()
    // })
}

function editRepoName (repo, value, repoDiv) {
    // book.users.push(userName)
    fetch(`http://localhost:3000/repos/${repo.id}`, {
    method: "PATCH",
    headers: {
    "Content-Type": "application/json",
    Accept: "application/json"
    },
    body: JSON.stringify({nickname: value})
    })
    .then(res => res.json())
    // .then(res => console.log(res))
    .then(updatedRepo => showRepo(updatedRepo))
    .catch(error => console.log(error))

}

 function editUser(currentUser, value) {
    fetch(`http://localhost:3000/users/${currentUser.id}`, {
    method: "PATCH",
    headers: {
    "Content-Type": "application/json",
    Accept: "application/json"
    },
    body: JSON.stringify({name: value})
    })
    .then(res => res.json())
    .then(res => {
        console.log(`${currentUser.name} before update`)
        console.log(`${res.name} returned result from db`)
        editedUser = res 
        console.log(`${editedUser.name} after update`)
        displayUserName(editedUser)
    })
    .catch(error => console.log(error))
    
 }

let button = document.getElementById("new-repo-form-button")
button.textContent = "Add a Repository"
button.addEventListener("click", () => {
    newRepoForm()
})

let editUserButton = document.getElementById("edit-user-button")
editUserButton.addEventListener("click", () => {
    manageUserForm();
})

function manageUserForm() {
    let form = document.createElement("form")
    form.innerHTML = ""
    let pleaseEditName = document.createElement("p")
    pleaseEditName.textContent = "Please enter your new username"

    let editNameInput = document.createElement("input")
    editNameInput.type = "text"
    editNameInput.name = "name"
    editNameInput.id = "edit-name-input"
    editNameInput.value = currentUser.name

    let submitButton = document.createElement("button")
    submitButton.textContent = "Submit Changes"

    form.addEventListener("submit", (event) => {
        event.preventDefault();
        const value = document.getElementById("edit-name-input").value
        editUser(currentUser, value)
        form.remove();
    })

    let deleteButton = document.createElement("button")
    deleteButton.textContent = "Delete this user"

    deleteButton.addEventListener("click", () => {
        deleteUser(currentUser);
    })

    form.appendChild(pleaseEditName)
    form.appendChild(editNameInput)
    form.appendChild(submitButton)
    form.appendChild(deleteButton)
    document.getElementById("user-div").appendChild(form)
}
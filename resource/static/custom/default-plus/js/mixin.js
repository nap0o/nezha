const mixinsVue = {
    data: {
        template: "default-plus"
    },
    created() {
        this.storedTemplate();
    },
    methods: {
        toggleTemplate() {
            const storeTtemplate = localStorage.getItem("template")
            if(storeTtemplate=="default-plus"){
                this.template = "server-status";
            }else{
                this.template = "default-plus";
            }
            localStorage.setItem("template", JSON.stringify(this.template));
            return this.template;
        },
        storedTemplate() {
            const storedTemplate = localStorage.getItem("template");
            if (storedTemplate !== null) {
                this.template = JSON.parse(storedTemplate);
            }       
        }
    }
}